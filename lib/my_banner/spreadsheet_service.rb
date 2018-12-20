require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

module MyBanner
  class SpreadsheetService

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob"
    CREDENTIALS_PATH = "auth/spreadsheet_credentials.json"
    TOKEN_PATH = "auth/spreadsheet_token.yaml"
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    def execute
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = "Google Sheets API Ruby Quickstart"
      service.authorization = authorize

      spreadsheet_id = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
      range = 'Class Data!A2:E'
      response = service.get_spreadsheet_values(spreadsheet_id, range)
      puts 'Name, Major:'
      puts 'No data found.' if response.values.empty?
      response.values.each do |row|
        puts "#{row[0]}, #{row[4]}"
      end
    end

    def authorize
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the ' \
            "resulting code after authorization:\n" + url
        code = $stdin.gets.chomp
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

  end
end
