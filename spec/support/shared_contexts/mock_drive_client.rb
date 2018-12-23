#
# @example include_context "mock drive client"
#
RSpec.shared_context "mock drive client" do
  include_context "mock drive authorization"

  let(:mock_drive_client) { MyBanner::DriveClient.new(mock_drive_authorization) }

end
