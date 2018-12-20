require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetAuthorization < GoogleAuthorization

    # permission to read and write ("https://www.googleapis.com/auth/calendar")
    # @see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/sheets_v4.rb#L39-L43
    AUTH_SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/spreadsheet_credentials.json"
      options[:token_filepath] ||= "auth/spreadsheet_token.yaml"
      super(options)
    end

  end
end
