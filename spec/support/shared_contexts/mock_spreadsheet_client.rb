#
# @example include_context "mock spreadsheet client"
#
RSpec.shared_context "mock spreadsheet client" do

  let(:credentials_filepath) { "spec/mocks/auth/spreadsheet_credentials.json" }
  let(:token_filepath) { "spec/mocks/auth/spreadsheet_token.yaml" }
  let(:authorization) { MyBanner::SpreadsheetAuthorization.new(credentials_filepath: credentials_filepath, token_filepath: token_filepath) }
  let(:mock_spreadsheet_client) { MyBanner::SpreadsheetClient.new(authorization.stored_credentials) }

end
