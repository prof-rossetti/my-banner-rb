module MyBanner
  RSpec.describe SpreadsheetClient do
    include_context "mock spreadsheet authorization"

    let(:client) { described_class.new(mock_spreadsheet_authorization) }

    it "has client options" do
      opts = client.client_options
      expect(opts).to be_kind_of(Struct)
      expect(opts.application_name).to eql("MyBanner Spreadsheet Client")
      expect(opts.application_version).to eql(MyBanner::VERSION)
    end

    it "has client credentials and user refresh token" do
      creds = client.authorization
      expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
      expect(creds.client_id).to eql("mock-spreadsheet-client-id.apps.googleusercontent.com")
      expect(creds.client_secret).to eql("mock-spreadsheet-client-secret")
      expect(creds.scope).to eql(["https://www.googleapis.com/auth/spreadsheets"])
      expect(creds.refresh_token).to eql("mock-spreadsheet-refresh-token")
      expect(creds.expires_at).to be_kind_of(Time)
      expect(creds.expiry).to eql(60)
    end

    it "makes requests on behalf of the user" do
      expect(client).to respond_to(:get_spreadsheet)
      expect(client).to respond_to(:create_spreadsheet)
      expect(client).to respond_to(:update_spreadsheet_value)
    end

  end
end
