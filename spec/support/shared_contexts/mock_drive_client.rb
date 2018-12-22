#
# @example include_context "mock drive client"
#
RSpec.shared_context "mock drive client" do

  let(:credentials_filepath) { "spec/mocks/auth/drive_credentials.json" }
  let(:token_filepath) { "spec/mocks/auth/drive_token.yaml" }
  let(:authorization) { MyBanner::DriveAuthorization.new(credentials_filepath: credentials_filepath, token_filepath: token_filepath) }
  let(:mock_drive_client) { MyBanner::DriveClient.new(authorization.stored_credentials) }

end
