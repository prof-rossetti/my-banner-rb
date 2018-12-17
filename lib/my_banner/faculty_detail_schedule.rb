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
      [
        MyBanner::Section.new(title: "Intro to Programming", section: 20, schedule_info:{}),
        MyBanner::Section.new(title: "Advanced Programming", section: 40, schedule_info:{}),
        MyBanner::Section.new(title: "Advanced Programming", section: 41, schedule_info:{}),
      ] # todo: parse HTML
    end

    TABLE_SUMMARIES = {
      info: "This layout table is used to present instructional assignments for the selected Term..",
      enrollment: "This table displays enrollment and waitlist counts.",
      schedule: "This table lists the scheduled meeting times and assigned instructors for this class.."
    }

    def sections_metadata
      results = []
      tablesets.each do |tableset|
        summaries = tableset.map { |t| t.attributes["summary"].value }
        raise "Unexpected tableset: #{summaries}" unless summaries.sort == TABLE_SUMMARIES.values.sort

        info_table =  tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:info] }
        enrollment_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:enrollment] }
        schedule_table = tableset.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:schedule] }
        raise "Unexpected tableset: #{summaries}" unless info_table && enrollment_table && schedule_table

        #binding.pry

        results << {
          title: "ABC",
          section: "009"
        }
      end
      results
    end

    def tablesets
      batches = tables.to_a.in_groups_of(3).map { |batch| batch }
      #summaries = tableset.map { |t| t.attributes["summary"].value }
      #raise "Unexpected tableset: #{summaries}" unless summaries.sort == TABLE_SUMMARIES.values.sort
      batches
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
