module MyBanner
  RSpec.describe SpreadsheetAuthorization do

    it_behaves_like "a GoogleAuthorization" do
      let(:scope) { "https://www.googleapis.com/auth/spreadsheets" }
      let(:credentials_filepath) { "spec/mocks/auth/spreadsheet_credentials.json" }
      let(:token_filepath) { "spec/mocks/auth/spreadsheet_token.yaml" }

      let(:client_id) { "mock-spreadsheet-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-spreadsheet-client-secret" }
      let(:refresh_token) { "mock-spreadsheet-refresh-token" }
    end

  end
end
