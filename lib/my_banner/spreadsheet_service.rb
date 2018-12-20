

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    def execute
      request_options = {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25}
      docs = drive_client.list_files(request_options) #> Google::Apis::DriveV3::FileList

      doc_title = "Gradebook - INFO 101 (201905)"
      doc = docs.files.find{|f| f.name == doc_title } #> Google::Apis::DriveV3::File:0x007f8585e67cd0

      if doc
        puts "FOUND EXISTING DOCUMENT: #{doc.id}"
        puts "FETCHING THE SPREADSHEET..."
        spreadsheet = client.get_spreadsheet(doc.id) #> #> Google::Apis::SheetsV4::Spreadsheet
      else
        puts "CREATING THE SPREADSHEET..."
        new_spreadsheet_attrs = {properties: {title: doc_title}}
        new_spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(new_spreadsheet_attrs)
        spreadsheet = client.create_spreadsheet(new_spreadsheet) #> Google::Apis::SheetsV4::Spreadsheet
      end

      puts "ID: #{spreadsheet.spreadsheet_id}"
      puts "SHEETS/TABS:"
      spreadsheet.sheets.each do |sheet|
        cols = sheet.properties.grid_properties.column_count
        rows = sheet.properties.grid_properties.row_count
        puts "  + #{sheet.properties.title} (#{cols} cols x #{rows} rows)"
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
