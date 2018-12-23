require "google/apis/drive_v3"
require "google/apis/drive_v3"

module MyBanner
  class DriveAuthorization < GoogleAuthorization

    AUTH_SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_FILE #> "https://www.googleapis.com/auth/drive.file"

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/drive_credentials.json"
      options[:token_filepath] ||= "auth/drive_token.yaml"
      super(options)
    end

  end
end
