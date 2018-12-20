

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    attr_reader :spreadsheet_title, :sheet_name, :sheet_values

    def initialize
      @spreadsheet_title = "Gradebook - INFO 101 (20190XYZ)" # todo: get from section/roster
      @sheet_name = "Sheet1" # todo: "Roster #{Date.today.to_s}"
      @sheet_values = [["email", "registration_number", "net_id"]] + 9.times.map { |i| ["student#{i+1}@example.edu", i+1, "student#{i+1}"] } # todo: get from section/roster
    end

    def execute
      update_values
    end

    # @return Google::Apis::SheetsV4::UpdateValuesResponse
    def update_values
      range = "#{sheet_name}!A1"
      vals = Google::Apis::SheetsV4::ValueRange.new(values: sheet_values)
      client.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, vals, value_input_option: "RAW")
    end

    # @return Google::Apis::SheetsV4::Spreadsheet
    def spreadsheet
      @spreadsheet ||= begin
        doc = docs.files.find { |f| f.name == spreadsheet_title } #> Google::Apis::DriveV3::File:0x007f8585e67cd0
        if doc
          client.get_spreadsheet(doc.id)
        else
          #binding.pry
          #grid_properties = Google::Apis::SheetsV4::GridProperties.new(column_count: 5, row_count: 19)
          roster_sheet = Google::Apis::SheetsV4::Sheet.new(properties: {title: "Roster", sheet_type: "GRID"})
          new_spreadsheet_attrs = { properties: {title: spreadsheet_title}, sheets: [roster_sheet] }
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

  end
end
