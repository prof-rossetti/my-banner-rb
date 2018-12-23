require "google/apis/drive_v3"

module MyBanner
  class DriveClient < Google::Apis::DriveV3::DriveService

    # @param authorization [DriveAuthorization]
    def initialize(authorization=nil)
      super()
      self.client_options.application_name = "MyBanner Drive Client"
      self.client_options.application_version = VERSION
      authorization ||= DriveAuthorization.new
      self.authorization = authorization.stored_credentials || authorization.user_provided_credentials
    end

  end
end
