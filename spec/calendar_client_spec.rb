module MyBanner
  RSpec.describe CalendarClient do

    let(:credentials_filepath) { "spec/mocks/calendar_auth/credentials.json" }
    let(:token_filepath) { "spec/mocks/calendar_auth/token.yaml" }
    let(:client) { described_class.new(credentials_filepath: credentials_filepath, token_filepath: token_filepath) }

    it "has client options" do
      opts = client.client_options
      expect(opts).to be_kind_of(Struct)
      expect(opts.application_name).to eql("MyBanner Calendar Client")
      expect(opts.application_version).to eql("0.1.0")
    end

    it "makes requests" do
      expect(client).to respond_to(:list_calendar_lists)
      expect(client).to respond_to(:insert_calendar)
      expect(client).to respond_to(:delete_event)
      expect(client).to respond_to(:list_events)
      expect(client).to respond_to(:update_event)
      expect(client).to respond_to(:insert_event)
    end

    describe "@authorization" do
      it "provides credentials and refresh token" do
        creds = client.authorization
        expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
        expect(creds.client_id).to eql("mock-client-id.apps.googleusercontent.com")
        expect(creds.client_secret).to eql("mock-client-secret")
        expect(creds.scope).to eql(["https://www.googleapis.com/auth/calendar"])
        expect(creds.refresh_token).to eql("mock-refresh-token")
        expect(creds.expires_at).to be_kind_of(Time)
        expect(creds.expiry).to eql(60)
      end
    end

  end
end
