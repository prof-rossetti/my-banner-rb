require "nokogiri"
require "active_support/core_ext/array"

module MyBanner
  class Schedule # consider Page, SchedulePage, DetailSchedulePage, FacultyDetailSchedulePage

    attr_reader :filepath

    def initialize(filepath=nil)
      @filepath = filepath || "pages/faculty-detail-schedule.html"
      validate_file_exists
    end

    def sections
      @sections ||= tablesets.map{ |tableset| tableset.section }
    end

    def tablesets
      @tablesets ||= tables.to_a.in_groups_of(3).map do |batch|
        summaries = batch.map { |t| t.attributes["summary"].value.squish }
        raise "Unexpected tableset: #{summaries}" unless summaries.sort == TABLE_SUMMARIES.values.sort
        info_table = batch.find { |t| t.attributes["summary"].value.squish == TABLE_SUMMARIES[:info].squish }
        enrollment_table = batch.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:enrollment] }
        schedule_table = batch.find { |t| t.attributes["summary"].value == TABLE_SUMMARIES[:schedule] }
        Tableset.new(info_table, enrollment_table, schedule_table)
      end
    end

    TABLE_SUMMARIES = {
      info: "This layout table is used to present instructional assignments for the selected Term..",
      enrollment: "This table displays enrollment and waitlist counts.",
      schedule: "This table lists the scheduled meeting times and assigned instructors for this class.."
    }

    # @return Nokogiri::XML::NodeSet
    def tables
      @tables ||= doc.css(".pagebodydiv").css("table").css(".datadisplaytable") # ignores the last table
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
