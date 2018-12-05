module MyBanner
  RSpec.describe CalendarAuthorizer do
    let(:scope) { "https://www.googleapis.com/auth/calendar" }
    let(:credentials_filepath) { "spec/mocks/calendar_auth/credentials.json" }
    let(:token_filepath) { "spec/mocks/calendar_auth/token.yaml" }
    let(:authorizer) { described_class.new(scope, credentials_filepath, token_filepath) }

    let(:mock_client_id) { "mock-client-id.apps.googleusercontent.com" }
    let(:redirect_uri) { "urn:ietf:wg:oauth:2.0:oob" }

    describe "#credentials" do
      let(:credentials) { authorizer.credentials }

      context "from existing file" do
        it "returns google credentials" do
          expect(credentials).to be_kind_of(Google::Auth::UserRefreshCredentials)
          expect(credentials.client_id).to eql(mock_client_id)
          expect(credentials.client_secret).to eql("mock-client-secret")
          expect(credentials.refresh_token).to eql("mock-refresh-token")
          expect(credentials.expires_at).to be_kind_of(Time)
          expect(credentials.expiry).to eql(60)
          expect(credentials.scope).to eql([scope])
        end
      end
    end

    describe "#authorization_url" do
      it "prompts the user to login via google" do
        expect(authorizer.authorization_url).to eql( "https://accounts.google.com/o/oauth2/auth?access_type=offline&approval_prompt=force&client_id=#{mock_client_id}&include_granted_scopes=true&redirect_uri=#{redirect_uri}&response_type=code&scope=#{scope}")
      end
    end




    #let(:token_request_body) { {
    #  "client_id"=>"mock-client-id.apps.googleusercontent.com",
    #  "client_secret"=>"mock-client-secret",
    #  "grant_type"=>"refresh_token",
    #  "refresh_token"=>"mock-refresh-token"
    #} }

    #before(:each) do
    #  stub_request(:post, "https://oauth2.googleapis.com/token").with(
    #    body: {
    #      "client_id"=>"abc123.apps.googleusercontent.com",
    #      "client_secret"=>"SKSJW9271HFG510PF",
    #      "grant_type"=>"refresh_token",
    #      "refresh_token"=>"26FGDNCO03HJMS"
    #    },
    #    headers: {
    #      'Accept'=>'*/*',
    #      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #      'Content-Type'=>'application/x-www-form-urlencoded',
    #      'User-Agent'=>'Faraday v0.15.3'
    #    }
    #  ).to_return(status: 200, body: "", headers: {})
    #end






  end
end
