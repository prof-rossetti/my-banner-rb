#
# @example include_context "mock drive authorization"
#
RSpec.shared_context "mock drive authorization" do

  let(:mock_drive_authorization) {
    MyBanner::DriveAuthorization.new(
      credentials_filepath: "spec/mocks/auth/drive_credentials.json",
      token_filepath: "spec/mocks/auth/drive_token.yaml"
    )
  }

end
