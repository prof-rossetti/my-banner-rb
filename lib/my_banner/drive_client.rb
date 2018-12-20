require "google/apis/drive_v3"

module MyBanner
  class DriveClient < Google::Apis::DriveV3::DriveService

    def initialize(authorization=nil)
      super()
      self.client_options.application_name = "MyBanner Drive Client"
      self.client_options.application_version = VERSION
      auth = DriveAuthorization.new
      self.authorization = authorization || auth.stored_credentials || auth.user_provided_credentials
    end

  end
end
