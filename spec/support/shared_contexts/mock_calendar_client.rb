#
# @example include_context "mock calendar client"
#
RSpec.shared_context "mock calendar client" do
  include_context "mock calendar authorization"

  let(:mock_calendar_client) { MyBanner::CalendarClient.new(mock_calendar_authorization) }
end
