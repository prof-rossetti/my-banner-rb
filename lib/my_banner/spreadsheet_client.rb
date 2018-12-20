require "google/apis/calendar_v3"

module MyBanner
  class SpreadsheetClient < Google::Apis::SheetsV4::SheetsService

    def initialize(authorization=nil)
      super()
      self.client_options.application_name = "MyBanner Spreadsheet Client"
      self.client_options.application_version = VERSION
      auth = SpreadsheetAuthorization.new
      self.authorization = authorization || auth.stored_credentials || auth.user_provided_credentials
    end

  end
end
