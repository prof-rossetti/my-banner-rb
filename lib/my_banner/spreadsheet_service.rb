

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


      data = 10.times.map { |i| ["email#{i}@example.com", "ABC123", i] }
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: data)
      range = "Sheet1!A1"
      #response = client.append_spreadsheet_value(spreadsheet.spreadsheet_id, range, value_range, value_input_option: "RAW") # adds rows after existing ones
      response = client.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, value_range, value_input_option: "RAW") # replaces existing ones

      #fields = ["spreadsheetId", "tableRange", "updates"]
      #fields = "spreadsheetId tableRange updates"
      #fr = client.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, value_range, value_input_option: "RAW", fields: fields)

      range = "Sheet1!A1:E10"
      response = client.get_spreadsheet_values(spreadsheet.spreadsheet_id, range)
      response.values.each do |row|
        puts "      #{row.join(" | ")}"
      end

    end

    def client
      @client ||= SpreadsheetClient.new
    end

    def drive_client
      @drive_client ||= DriveClient.new
    end

  end
end
