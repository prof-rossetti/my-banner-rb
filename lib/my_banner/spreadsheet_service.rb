

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    def execute
      spreadsheet_id = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
      range = 'Class Data!A2:E'
      response = client.get_spreadsheet_values(spreadsheet_id, range)
      puts 'Name, Major:'
      puts 'No data found.' if response.values.empty?
      response.values.each do |row|
        puts "#{row[0]}, #{row[4]}"
      end
    end

    def client
      @client ||= begin
        sheets_client = Google::Apis::SheetsV4::SheetsService.new
        sheets_client.client_options.application_name = "MyBanner Spreadsheet Client"
        sheets_client.client_options.application_version = VERSION
        auth = SpreadsheetAuthorization.new
        sheets_client.authorization = auth.stored_credentials || auth.user_provided_credentials
        sheets_client
      end
    end

  end
end
