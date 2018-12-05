module MyBanner
  RSpec.describe CalendarAuthorizer do
    let(:scope) { "https://www.googleapis.com/auth/calendar" }
    let(:credentials_filepath) { "spec/mocks/calendar_auth/credentials.json" }
    let(:token_filepath) { "spec/mocks/calendar_auth/token.yaml" }
    let(:authorizer) { described_class.new(scope, credentials_filepath, token_filepath) }

    describe "#credentials" do
      context "from existing file" do
        it "returns google credentials" do
          creds = authorizer.credentials
          expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
          expect(creds.client_id).to eql("mock-client-id.apps.googleusercontent.com")
          expect(creds.client_secret).to eql("mock-client-secret")
          expect(creds.refresh_token).to eql("mock-refresh-token")
          expect(creds.expires_at).to be_kind_of(Time)
          expect(creds.expiry).to eql(60)
          expect(creds.scope).to eql([scope])
          #expect(creds.authorization_uri).to eql("AUTH URI")
        end
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
