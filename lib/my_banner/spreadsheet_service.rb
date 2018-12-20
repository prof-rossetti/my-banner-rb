

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    attr_reader :spreadsheet_title, :sheet_name, :sheet_values

    def initialize
      @spreadsheet_title = "Gradebook - INFO 101 (201905)" # todo: get from section/roster
      @sheet_name = "Sheet1" # todo: "Roster #{Date.today.to_s}"
      @sheet_values = [["email", "registration_number", "net_id"]] + 9.times.map { |i| ["student#{i+1}@example.edu", i+1, "student#{i+1}"] } # todo: get from section/roster
    end

    def execute
      puts ""
      setter_values = Google::Apis::SheetsV4::ValueRange.new(values: sheet_values)
      setter_range = "#{sheet_name}!A1"
      setter_response = client.update_spreadsheet_value(spreadsheet.spreadsheet_id, setter_range, setter_values, value_input_option: "RAW")
      pp setter_response.to_h
      puts ""
      getter_range = "#{sheet_name}!A1:C10"
      getter_response = client.get_spreadsheet_values(spreadsheet.spreadsheet_id, getter_range)
      getter_response.values.each do |row|
        puts "  #{row.join(" | ")}"
      end
    end

    # @return Google::Apis::SheetsV4::Spreadsheet
    def spreadsheet
      @spreadsheet ||= begin
        doc = docs.files.find { |f| f.name == spreadsheet_title } #> Google::Apis::DriveV3::File:0x007f8585e67cd0
        if doc
          client.get_spreadsheet(doc.id)
        else
          new_spreadsheet_attrs = {properties: {title: spreadsheet_title}}
          new_spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(new_spreadsheet_attrs)
          client.create_spreadsheet(new_spreadsheet)
        end
      end
    end

    # @return Google::Apis::DriveV3::FileList
    def docs
      @docs ||= begin
        request_options = {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25}
        drive_client.list_files(request_options)
      end
    end

    def client
      @client ||= SpreadsheetClient.new
    end

    def drive_client
      @drive_client ||= DriveClient.new
    end









    #def inspect_spreadsheet
    #  puts "ID: #{spreadsheet.spreadsheet_id}"
    #  puts "SHEETS/TABS:"
    #  spreadsheet.sheets.each do |sheet|
    #    cols = sheet.properties.grid_properties.column_count
    #    rows = sheet.properties.grid_properties.row_count
    #    puts "  + #{sheet.properties.title} (#{cols} cols x #{rows} rows)"
    #  end
    #end





  end
end
