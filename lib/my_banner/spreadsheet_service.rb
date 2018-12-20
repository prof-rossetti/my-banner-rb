

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    def execute
      request_options = {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25}
      all_sheets = drive_client.list_files(request_options) #> Google::Apis::DriveV3::FileList

      sheet_name = "Gradebook - INFO 101 (201909)"
      sheet = all_sheets.files.find{|f| f.name == sheet_name }
      if sheet
        puts "FOUND THE SHEET: #{sheet.id}"
        #
      else
        puts "CREATING NEW SHEET..."
        # create the sheet
        # sheet = _________
      end

      #spreadsheet_id = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
      #range = 'Class Data!A2:E'
      #response = client.get_spreadsheet_values(spreadsheet_id, range)
      #puts 'Name, Major:'
      #puts 'No data found.' if response.values.empty?
      #response.values.each do |row|
      #  puts "#{row[0]}, #{row[4]}"
      #end

    end

    def client
      @client ||= SpreadsheetClient.new
    end

    def drive_client
      @drive_client ||= DriveClient.new
    end

  end
end
