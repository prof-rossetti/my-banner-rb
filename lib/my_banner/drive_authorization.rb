require "google/apis/drive_v3"

module MyBanner
  class DriveAuthorization < GoogleAuthorization

    # permission to read metadata only
    # @see: https://github.com/googleapis/google-api-ruby-client/blob/ddcba569d3a94493d8e355298f221fd6e8eb8486/generated/google/apis/drive_v3.rb#L31-L53
    AUTH_SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_METADATA_READONLY

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/drive_credentials.json"
      options[:token_filepath] ||= "auth/drive_token.yaml"
      super(options)
    end

  end
end
