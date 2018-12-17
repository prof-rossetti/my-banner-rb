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

        info_table =  tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:info] } #> Nokogiri::XML::Element
        enrollment_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:enrollment] } #> Nokogiri::XML::Element
        schedule_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:schedule] } #> Nokogiri::XML::Element
        raise "Unexpected tableset: #{summaries}" unless info_table && enrollment_table && schedule_table

        #info_rows = info_table.css("tr")
        #raise "Unexpected number of info table rows: #{info_rows.count}" unless info_rows.count == 12

        enrollment_rows = enrollment_table.css("tr")
        raise "Unexpected number of enrollment table rows: #{enrollment_rows.count}" unless enrollment_rows.count == 3
        enrollment_row = enrollment_rows[1]
        raise "Unrecognized enrollment row" unless enrollment_row.css("th").text == "Enrollment:"
        raise "Unrecognized enrollment data" unless enrollment_row.css("td").count == 3

        enrollment_max = enrollment_row.css("td")[0].text.to_i
        enrollment_actual = enrollment_row.css("td")[1].text.to_i
        enrollment_remaining = enrollment_row.css("td")[2].text.to_i

        schedule_rows = schedule_table.css("tr")
        raise "Unexpected number of schedule table rows: #{schedule_rows.count}" unless schedule_rows.count == 2

        #binding.pry
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
          enrollment_counts: {maximum: enrollment_max, actual: enrollment_actual, remaining: enrollment_remaining},
          scheduled_meeting_times: {
            type: "Lecture",
            time: "11:00 am - 12:20 pm",
            days: "TR",
            where: "Science Building 111",
            date_range: "Oct 29, 2018 - Dec 18, 2018",
            schedule_type: "Lecture",
            instructors: ["Polly Professor"]
          }
        }

        results << metadata
      end
      results
    end

    def tablesets
      tables.to_a.in_groups_of(3).map { |batch| batch }
    end

    # @return Nokogiri::XML::NodeSet
    def tables
      doc.css(".pagebodydiv").css("table")
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
