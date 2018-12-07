module MyBanner
  RSpec.describe CalendarAuthorizer do
    let(:scope) { "https://www.googleapis.com/auth/calendar" }
    let(:credentials_filepath) { "spec/mocks/calendar_auth/credentials.json" }
    let(:token_filepath) { "spec/mocks/calendar_auth/token.yaml" }
    let(:calendar_authorizer) { described_class.new(scope: scope, credentials_filepath: credentials_filepath, token_filepath: token_filepath) }

    let(:client_id) { "mock-client-id.apps.googleusercontent.com" }
    let(:client_secret) { "mock-client-secret" }
    let(:refresh_token) { "mock-refresh-token" }

    let(:user_code) { "mock-user-auth-code" }
    let(:redirect_uri) { "urn:ietf:wg:oauth:2.0:oob" }

    describe "#authorizer" do
      it "manages credential files" do
        expect(File.exist?(token_filepath)).to eql(true)
        auth = calendar_authorizer.authorizer
        expect(auth).to be_kind_of(Google::Auth::UserAuthorizer)
        expect(auth).to respond_to(:get_credentials)
        expect(auth).to respond_to(:get_and_store_credentials_from_code)
        expect(auth).to respond_to(:get_authorization_url)
      end
    end

    describe "#credentials" do
      context "with stored token" do
        it "returns google credentials" do
          expect(File.exist?(token_filepath)).to eql(true)
          creds = calendar_authorizer.credentials
          expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
          expect(creds.client_id).to eql(client_id)
          expect(creds.client_secret).to eql(client_secret)
          expect(creds.refresh_token).to eql(refresh_token)
          expect(creds.expires_at).to be_kind_of(Time)
          expect(creds.expiry).to eql(60)
          expect(creds.scope).to eql([scope])
        end
      end

      context "without stored token" do
        let(:token_filepath) { "spec/mocks/calendar_auth/temp_token.yaml" }

        let(:mock_credentials) { Google::Auth::UserRefreshCredentials.new(
          client_id: client_id,
          client_secret: client_secret,
          scope: scope,
          refresh_token: refresh_token,
        ) }

        before(:each) do
          allow(calendar_authorizer).to receive(:user_provided_credentials).and_return(mock_credentials)
        end

        it "returns google credentials" do
          expect(File.exist?(token_filepath)).to eql(false)
          expect(calendar_authorizer.stored_credentials).to eql(nil)
          creds = calendar_authorizer.credentials
          expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
          expect(creds.client_id).to eql(client_id)
          expect(creds.client_secret).to eql(client_secret)
          expect(creds.refresh_token).to eql(refresh_token)
          #expect(creds.expires_at).to be_kind_of(Time)
          #expect(creds.expiry).to eql(60)
          expect(creds.scope).to eql([scope])
        end
      end
    end

    describe "#stored_credentials" do
      it "returns google credentials" do
        expect(File.exist?(token_filepath)).to eql(true)
        creds = calendar_authorizer.stored_credentials
        expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
        expect(creds.client_id).to eql(client_id)
        expect(creds.client_secret).to eql(client_secret)
        expect(creds.refresh_token).to eql(refresh_token)
        expect(creds.expires_at).to be_kind_of(Time)
        expect(creds.expiry).to eql(60)
        expect(creds.scope).to eql([scope])
      end
    end

    describe "#user_provided_credentials" do
      let(:token_filepath) { "spec/mocks/calendar_auth/temp_token.yaml" }

      before(:each) do
        FileUtils.rm_rf(token_filepath)

        allow(calendar_authorizer).to receive(:user_provided_code).and_return(user_code)

        stub_request(:post, "https://oauth2.googleapis.com/token").with(
          body: {
            "client_id"=> client_id,
            "client_secret"=> client_secret,
            "code"=> user_code,
            "grant_type"=>"authorization_code",
            "redirect_uri"=>redirect_uri
          },
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'User-Agent'=>'Faraday v0.15.3'
          }
        ).to_return(status: 200, body: "", headers: {})
        # for some reason, this is producing ArgumentError Invalid content type ''
        # ... see https://github.com/googleapis/signet/blob/master/lib/signet/oauth_2.rb#L85
        # ... so try to bypass that error:
        allow(Signet::OAuth2).to receive(:parse_credentials)
      end

      after(:each) { FileUtils.rm_rf(token_filepath) }

      it "makes a token request and returns google credentials" do
        expect(calendar_authorizer.user_provided_credentials).to be_kind_of(Google::Auth::UserRefreshCredentials)
      end
    end

    describe "#user_provided_code" do
      before(:each) do
        allow($stdin).to receive(:gets).and_return(user_code)
        allow(STDOUT).to receive(:puts) # suppress puts statement
      end

      it "prompts the user for a code" do
        expect(calendar_authorizer.user_provided_code).to eql(user_code) # looks like "module MyBanner" is the deafult when there is no mocking...
      end
    end

    describe "#authorization_url" do
      let(:redirect_uri) { "urn:ietf:wg:oauth:2.0:oob" }

      it "provides a place for the user to login to google" do
        expect(calendar_authorizer.authorization_url).to eql("https://accounts.google.com/o/oauth2/auth?access_type=offline&approval_prompt=force&client_id=#{client_id}&include_granted_scopes=true&redirect_uri=#{redirect_uri}&response_type=code&scope=#{scope}")
      end
    end
  end
end
