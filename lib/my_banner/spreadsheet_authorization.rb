require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetAuthorization < GoogleAuthorization

    AUTH_SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS #> "https://www.googleapis.com/auth/spreadsheets"

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/spreadsheet_credentials.json"
      options[:token_filepath] ||= "auth/spreadsheet_token.yaml"
      super(options)
    end

  end
end
