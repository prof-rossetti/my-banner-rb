require "nokogiri"

module MyBanner
  class FacultyDetailSchedule # < Page

    attr_reader :filepath

    def initialize(filepath=nil)
      @filepath ||= "pages/faculty-detail-schedule.html"
      validate_file_exists
    end

    def sections
      [
        MyBanner::Section.new(title: "Intro to Programming", section: 20, schedule_info:{}),
        MyBanner::Section.new(title: "Advanced Programming", section: 40, schedule_info:{}),
        MyBanner::Section.new(title: "Advanced Programming", section: 41, schedule_info:{}),
      ] # todo: parse HTML
    end

    def parse_html
      binding.pry
    end

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
