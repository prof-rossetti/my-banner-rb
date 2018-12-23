#
# @example include_context "mock spreadsheet authorization"
#
RSpec.shared_context "mock spreadsheet authorization" do

  let(:mock_spreadsheet_authorization) {
    MyBanner::SpreadsheetAuthorization.new(
      credentials_filepath: "spec/mocks/auth/spreadsheet_credentials.json",
      token_filepath: "spec/mocks/auth/spreadsheet_token.yaml"
    )
  }

end
