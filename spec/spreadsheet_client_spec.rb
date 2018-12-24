module MyBanner
  RSpec.describe SpreadsheetClient do

    it_behaves_like "a google api client" do
      include_context "mock spreadsheet authorization"
      let(:client) { described_class.new(mock_spreadsheet_authorization) }
      let(:client_name) { "MyBanner Spreadsheet Client" }
      let(:client_id) { "mock-spreadsheet-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-spreadsheet-client-secret" }
      let(:auth_scope) { "https://www.googleapis.com/auth/spreadsheets" }
      let(:refresh_token) { "mock-spreadsheet-refresh-token" }
    end

    include_context "mock spreadsheet authorization"

    let(:client) { described_class.new(mock_spreadsheet_authorization) }

    it "makes requests on behalf of the user" do
      expect(client).to respond_to(:get_spreadsheet)
      expect(client).to respond_to(:create_spreadsheet)
      expect(client).to respond_to(:update_spreadsheet_value)
    end

  end
end
