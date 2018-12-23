module MyBanner
  RSpec.describe DriveAuthorization do

    it_behaves_like "a GoogleAuthorization" do
      let(:scope) { "https://www.googleapis.com/auth/drive.file" }
      let(:credentials_filepath) { "spec/mocks/auth/drive_credentials.json" }
      let(:token_filepath) { "spec/mocks/auth/drive_token.yaml" }

      let(:client_id) { "mock-drive-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-drive-client-secret" }
      let(:refresh_token) { "mock-drive-refresh-token" }
    end

  end
end
