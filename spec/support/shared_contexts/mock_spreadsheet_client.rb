#
# @example include_context "mock spreadsheet client"
#
RSpec.shared_context "mock spreadsheet client" do
  include_context "mock spreadsheet authorization"

  let(:mock_spreadsheet_client) { MyBanner::SpreadsheetClient.new(mock_spreadsheet_authorization) }
end
