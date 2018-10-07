module MyBanner
  class Section

    attr_accessor :metadata

    def initialize(metadata={})
      @metadata = metadata
    end

    def calendar_name
      "GU #{abbreviation}"
    end

    def abbreviation
      "#{metadata[:course]}-#{metadata[:section]}"
    end

    def start_date
      meeting_dates_range.first
    end

    def end_date
      meeting_dates_range.last
    end

    def weekdays
      metadata[:scheduled_meeting_times][:days].each_char.to_a
    end

    def start_time
      meeting_time_range.first
    end

    def end_time
      meeting_time_range.last
    end

    def location
      metadata[:scheduled_meeting_times][:where]
    end

    private

    def meeting_dates_range
      metadata[:scheduled_meeting_times][:date_range].split(" - ")
    end

    def meeting_time_range
      metadata[:scheduled_meeting_times][:time].split(" - ")
    end

  end
end
