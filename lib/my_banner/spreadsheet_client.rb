require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetClient < Google::Apis::SheetsV4::SheetsService

    # @param authorization [SpreadsheetAuthorization]
    def initialize(authorization=nil)
      super()
      self.client_options.application_name = "MyBanner Spreadsheet Client"
      self.client_options.application_version = VERSION
      authorization ||= SpreadsheetAuthorization.new
      self.authorization = authorization.stored_credentials || authorization.user_provided_credentials
    end

  end
end
