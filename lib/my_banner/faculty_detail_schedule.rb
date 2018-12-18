require "nokogiri"
require "active_support/core_ext/array"

module MyBanner
  class FacultyDetailSchedule # < Page
    attr_reader :filepath

    def initialize(filepath=nil)
      @filepath = filepath || "pages/faculty-detail-schedule.html"
      validate_file_exists
    end

    def sections
      @sections ||= sections_metadata.map{ |metadata| MyBanner::Section.new(metadata) }
    end

    TABLE_SUMMARIES = {
      info: "This layout table is used to present instructional assignments for the selected Term..",
      enrollment: "This table displays enrollment and waitlist counts.",
      schedule: "This table lists the scheduled meeting times and assigned instructors for this class.."
    }

    def sections_metadata
      results = []
      tablesets.each do |tableset|
        #summaries = tableset.map { |t| t.attributes["summary"].value }
        #raise "Unexpected tableset: #{summaries}" unless summaries.sort == TABLE_SUMMARIES.values.sort

        info_table = tableset.find { |t| t.attributes["summary"].value.squish == TABLE_SUMMARIES[:info].squish } #> Nokogiri::XML::Element
        # not sure why this is returning all three tables with all 51 rows. what is going on?...
        info_table = info_table.css("table").find { |t| t.attributes["summary"].value.squish == TABLE_SUMMARIES[:info].squish }
        # WTF IS GOING ON??????????????



        enrollment_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:enrollment] } #> Nokogiri::XML::Element
        schedule_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:schedule] } #> Nokogiri::XML::Element
        raise "Unexpected tableset: #{summaries}" unless info_table && enrollment_table && schedule_table

        info_rows = info_table.css("tr")
        #raise "Unexpected number of info table rows: #{info_rows.count}" unless info_rows.count == 12
        #binding.pry



        enrollment_rows = enrollment_table.css("tr")
        raise "Unexpected enrollment table row count: #{enrollment_rows.count}" unless enrollment_rows.count == 3
        enrollment_table_headers = ["", "Maximum", "Actual", "Remaining"]
        raise "Unexpected enrollment table headers" unless enrollment_rows[0].css("th").map(&:text) == enrollment_table_headers
        enrollment_row = enrollment_rows[1]
        raise "Unexpected enrollment table row" unless enrollment_row.css("th").text == "Enrollment:"
        raise "Unexpected enrollment table data" unless enrollment_row.css("td").count == 3
        enrollment_data = enrollment_row.css("td")
        enrollment_max = enrollment_data[0].text.to_i
        enrollment_actual = enrollment_data[1].text.to_i
        enrollment_remaining = enrollment_data[2].text.to_i

        # schedule table caption should be "Scheduled Meeting Times"
        schedule_rows = schedule_table.css("tr")
        raise "Unexpected schedule table row count: #{schedule_rows.count}" unless schedule_rows.count == 2
        schedule_table_headers = ["Type", "Time", "Days", "Where", "Date Range", "Schedule Type", "Instructors"]
        raise "Unexpected schedule table headers" unless schedule_rows[0].css("th").map(&:text) == schedule_table_headers
        schedule_row = schedule_rows[1]
        raise "Unexpected schedule table data" unless schedule_row.css("td").count == 7 # schedule_table_headers.count
        schedule_data = schedule_row.css("td")
        meeting_type = schedule_data[0].text
        meeting_times = schedule_data[1].text
        meeting_days = schedule_data[2].text
        meeting_location = schedule_data[3].text
        meeting_daterange = schedule_data[4].text
        meeting_schedule_type = schedule_data[5].text
        meeting_instructors = schedule_data[6].text.squish.split(",")

        metadata = {
          title: "Intro to Programming",
          crn: 123456,
          course: "INFO 101",
          section: 20,
          status: "OPEN",
          registration: "May 01, 2018 - Nov 02, 2018",
          college: "School of Business and Technology",
          department: "Information Systems",
          part_of_term: "C04",
          credits: 1.5,
          levels: ["Graduate", "Juris Doctor", "Undergraduate"],
          campus: "Main Campus",
          override: "No",
          enrollment_counts: { maximum: enrollment_max, actual: enrollment_actual, remaining: enrollment_remaining },
          scheduled_meeting_times: {
            type: meeting_type,
            time: meeting_times,
            days: meeting_days,
            where: meeting_location,
            date_range: meeting_daterange,
            schedule_type: meeting_schedule_type,
            instructors: meeting_instructors
          }
        }

        results << metadata
      end
      results
    end

    def tablesets
      @tablesets ||= tables.to_a.in_groups_of(3).map { |batch| batch }
    end

    # @return Nokogiri::XML::NodeSet
    def tables
      @tables ||= doc.css(".pagebodydiv").css("table")
    end

    # @return Nokogiri::XML::Document
    def doc
      @doc ||= File.open(filepath) { |f| Nokogiri::XML(f) }
    end

    private

    def validate_file_exists
      unless filepath && File.exists?(filepath)
        raise "Oh, couldn't find an HTML file at #{filepath}. Please download one and copy it to the expected location."
      end
    end

  end
end
