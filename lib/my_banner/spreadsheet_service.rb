#require 'google/apis/sheets_v4'
#require 'googleauth'
#require 'googleauth/stores/file_token_store'
#require 'fileutils'

module MyBanner
  class SpreadsheetService




=begin
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
    CREDENTIALS_PATH = 'credentials.json'
    TOKEN_PATH = 'token.yaml'.freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY






    def execute
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize


      # Prints the names and majors of students in a sample spreadsheet:
      # https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
      spreadsheet_id = '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms'
      range = 'Class Data!A2:E'
      response = service.get_spreadsheet_values(spreadsheet_id, range)
      puts 'Name, Major:'
      puts 'No data found.' if response.values.empty?
      response.values.each do |row|
        # Print columns A and E, which correspond to indices 0 and 4.
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
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end


=end






  end
end
