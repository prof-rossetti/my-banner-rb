module MyBanner
  class Page

    def parse
      scheduled_sections
    end

    def scheduled_sections
      [].map { |section_metadata| Section.new(section_metadata) } # todo: parse the HTML page
    end

  end
end
