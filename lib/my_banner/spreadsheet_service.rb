

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService
    attr_reader :spreadsheet_title #, :sheet_name #, :sheet_values

    def initialize(spreadsheet_title)
      @spreadsheet_title = spreadsheet_title
      #@sheet_name = "roster-todo" # todo: "roster-#{Date.today.to_s}"
      #@sheet_values = [["email", "registration_number", "net_id"]] + 27.times.map { |i| ["student#{i+1}@todo.edu", i+1, "student#{i+1}"] } # todo: get from roster
    end

    #def execute
    #  spreadsheet
    #  #update_values
    #end

    # # @return Google::Apis::SheetsV4::UpdateValuesResponse
    # def update_values
    #   range = "#{sheet_name}!A1"
    #   vals = Google::Apis::SheetsV4::ValueRange.new(values: sheet_values)
    #   client.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, vals, value_input_option: "RAW")
    # end

    # @return Google::Apis::SheetsV4::Spreadsheet
    def spreadsheet
      @spreadsheet ||= if spreadsheet_file
        client.get_spreadsheet(spreadsheet_file.id)
      else
        client.create_spreadsheet(new_spreadsheet)
      end
    end

    def client
      @client ||= SpreadsheetClient.new
    end

    def new_spreadsheet
      #roster_sheet = Google::Apis::SheetsV4::Sheet.new(properties: {title: sheet_name, sheet_type: "GRID"})
      #new_spreadsheet_attrs = { properties: {title: spreadsheet_title}, sheets: [roster_sheet] }
      new_spreadsheet_attrs = { properties: { title: spreadsheet_title } }
      Google::Apis::SheetsV4::Spreadsheet.new(new_spreadsheet_attrs)
    end

    #
    # DRIVE FILES
    #

    # @return Google::Apis::DriveV3::File
    def spreadsheet_file
      file_list.files.find { |f| f.name == spreadsheet_title }
    end

    # @return Google::Apis::DriveV3::FileList
    def file_list
      @file_list ||= begin
        request_options = {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25}
        drive_client.list_files(request_options)
      end
    end

    def drive_client
      @drive_client ||= DriveClient.new
    end

    private

    def delete_spreadsheet # DANGER!
      drive_client.delete_file(spreadsheet.spreadsheet_id)
    end

  end
end
