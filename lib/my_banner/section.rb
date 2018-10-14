module MyBanner
  class Section

    attr_accessor :metadata, :abbreviation, :title, :instructor, :location,
      :weekdays, :term_start, :term_end, :start_time, :end_time

    def initialize(metadata={})
      @metadata = metadata
      @abbreviation = "#{metadata[:course]}-#{metadata[:section]}"
      @title = metadata[:title]
      schedule_info = metadata[:scheduled_meeting_times]
      @instructor = schedule_info[:instructors].first
      @weekdays = schedule_info[:days].each_char.to_a
      @location = schedule_info[:where]
      term_info = schedule_info[:date_range] #todo: validate string splits into two-member array
      @term_start = Date.parse(term_info.split(" - ").first)
      @term_end = Date.parse(term_info.split(" - ").last)
      time_info = schedule_info[:time] #todo: validate string splits into two-member array
      @start_time = time_info.split(" - ").first
      @end_time = time_info.split(" - ").last
    end

    def calendar_name
      abbreviation
    end

    #def meetings
    #  meeting_dates #
    #end

    def meeting_dates
      term_date_range.select{|date| weekday_numbers.include?(date.wday) }
    end

    def term_date_range
      term_start..term_end
    end

    def term_date_range
      term_start..term_end
    end

    def weekday_numbers
      weekdays.map{|char| WEEKDAYS_MAP[char.to_sym] }
    end

    WEEKDAYS_MAP = { M: 1, T: 2, W: 3, R: 4, F: 5, S: 6, N: 0 } # S and N not yet verified

  end
end
