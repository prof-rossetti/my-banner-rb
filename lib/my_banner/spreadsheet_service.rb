

require "google/apis/sheets_v4"

module MyBanner
  class SpreadsheetService

    attr_reader :section, :spreadsheet_title, :sheet_name, :sheet_values

    alias_attribute :title, :spreadsheet_title
    alias_attribute :doc_title, :spreadsheet_title
    alias_attribute :document_title, :spreadsheet_title

    def initialize(section)
      @section = section
      validate_section
      @spreadsheet_title = "Gradebook - #{section.course} (#{section.term_start.strftime("%Y%m")})"
      @sheet_name = "roster-todo" # todo: "roster-#{Date.today.to_s}"
      @sheet_values = [["email", "registration_number", "net_id"]] + 9.times.map { |i| ["student#{i+1}@todo.edu", i+1, "student#{i+1}"] } # todo: get from roster
    end

    def execute
      binding.pry
      update_values
    end

    # @return Google::Apis::SheetsV4::UpdateValuesResponse
    def update_values
      # need to create sheet if it doesn't already exist
      range = "#{sheet_name}!A1"
      vals = Google::Apis::SheetsV4::ValueRange.new(values: sheet_values)
      client.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, vals, value_input_option: "RAW")
    end

    # @return Google::Apis::SheetsV4::Spreadsheet
    def spreadsheet
      @spreadsheet ||= begin
        if spreadsheet_file
          puts "DOCUMENT FOUND"
          client.get_spreadsheet(spreadsheet_file.id)
        else
          puts "DOCUMENT NOT FOUND"
          #binding.pry
          #grid_properties = Google::Apis::SheetsV4::GridProperties.new(column_count: 5, row_count: 19)
          roster_sheet = Google::Apis::SheetsV4::Sheet.new(properties: {title: sheet_name, sheet_type: "GRID"})
          new_spreadsheet_attrs = { properties: {title: spreadsheet_title}, sheets: [roster_sheet] }
          new_spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(new_spreadsheet_attrs)
          client.create_spreadsheet(new_spreadsheet)
        end
      end
    end

    def spreadsheet_file
      docs.files.find { |f| f.name == spreadsheet_title } #> Google::Apis::DriveV3::File:0x007f8585e67cd0
    end

    # @return Google::Apis::DriveV3::FileList
    def docs # consider file_list
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

    private

    def validate_section
      raise "OOPS, expecting a section object" unless section && section.is_a?(Section)
    end

  end
end
