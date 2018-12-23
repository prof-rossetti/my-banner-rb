#
# @example include_context "mock calendar authorization"
#
RSpec.shared_context "mock calendar authorization" do

  let(:mock_calendar_authorization) {
    MyBanner::CalendarAuthorization.new(
      credentials_filepath: "spec/mocks/auth/calendar_credentials.json",
      token_filepath: "spec/mocks/auth/calendar_token.yaml"
    )
  }

end
