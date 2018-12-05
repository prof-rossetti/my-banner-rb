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
        end
      end
    end

  end
end
