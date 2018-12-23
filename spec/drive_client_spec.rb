module MyBanner
  RSpec.describe DriveClient do
    include_context "mock drive authorization"

    let(:client) { described_class.new(mock_drive_authorization) }

    it "has client options" do
      opts = client.client_options
      expect(opts).to be_kind_of(Struct)
      expect(opts.application_name).to eql("MyBanner Drive Client")
      expect(opts.application_version).to eql("0.1.0")
    end

    it "has client credentials and user refresh token" do
      creds = client.authorization
      expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
      expect(creds.client_id).to eql("mock-drive-client-id.apps.googleusercontent.com")
      expect(creds.client_secret).to eql("mock-drive-client-secret")
      expect(creds.scope).to eql(["https://www.googleapis.com/auth/drive.file"])
      expect(creds.refresh_token).to eql("mock-drive-refresh-token")
      expect(creds.expires_at).to be_kind_of(Time)
      expect(creds.expiry).to eql(60)
    end

    it "makes requests on behalf of the user" do
      expect(client).to respond_to(:list_files)
      expect(client).to respond_to(:delete_file)
    end

  end
end
