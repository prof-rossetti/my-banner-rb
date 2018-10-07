module MyBanner
  class Page

    def parse
      scheduled_sections
    end

    def scheduled_sections
      [] # _____.map { |section_metadata| Section.new(section_metadata) }
    end

  end
end
