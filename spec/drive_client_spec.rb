module MyBanner
  RSpec.describe DriveClient do

    it_behaves_like "a google api client" do
      include_context "mock drive authorization"
      let(:client) { described_class.new(mock_drive_authorization) }
      let(:client_name) { "MyBanner Drive Client" }
      let(:client_id) { "mock-drive-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-drive-client-secret" }
      let(:auth_scope) { "https://www.googleapis.com/auth/drive.file" }
      let(:refresh_token) { "mock-drive-refresh-token" }
    end

    include_context "mock drive authorization"

    let(:client) { described_class.new(mock_drive_authorization) }

    it "makes requests on behalf of the user" do
      expect(client).to respond_to(:list_files)
      expect(client).to respond_to(:delete_file)
    end

  end
end
