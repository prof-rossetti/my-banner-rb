module MyBanner
  class Section

    attr_accessor :metadata, :abbreviation, :title, :instructor, :location,
      :time_zone, :weekdays, :term_start, :term_end, :start_time, :end_time

    def initialize(metadata={})
      @metadata = metadata
      @abbreviation = "#{metadata.try(:[], :course)}-#{metadata.try(:[], :section)}"
      @title = metadata.try(:[], :title)

      schedule_info = metadata.try(:[], :scheduled_meeting_times)
      @instructor = schedule_info.try(:[], :instructors).try(:first)
      @weekdays = schedule_info.try(:[], :days).try(:each_char).try(:to_a)
      @location = schedule_info.try(:[], :where)
      @time_zone = "America/New_York" #todo: lookup or customize

      term_info = schedule_info.try(:[], :date_range) #todo: validate string splits into two-member array
      @term_start = Date.parse( term_info.try(:split, " - ").try(:first) ) rescue nil
      @term_end = Date.parse( term_info.try(:split, " - ").try(:last) ) rescue nil

      time_info = schedule_info.try(:[], :time) #todo: validate string splits into two-member array
      @start_time = time_info.try(:split, " - ").try(:first)
      @end_time = time_info.try(:split, " - ").try(:last)
    end

    def calendar_name
      abbreviation
    end

    def meetings
      meeting_dates.map do |date|
        start_at = DateTime.parse("#{date} #{start_time}")
        end_at = DateTime.parse("#{date} #{end_time}")
        Meeting.new(start_at: start_at, end_at: end_at)
      end
    end

    def meeting_dates
      term_date_range.select{ |date| weekday_numbers.include?(date.wday) }
    end

    def term_date_range
      term_start..term_end
    end

    def weekday_numbers
      weekdays.map{|char| WEEKDAYS_MAP[char.to_sym] }
    end

    WEEKDAYS_MAP = { M: 1, T: 2, W: 3, R: 4, F: 5, S: 6, N: 0 } # S and N not yet verified

    class Meeting
      attr_reader :start_at, :end_at

      def initialize(options={})
        @start_at = options[:start_at]
        @end_at = options[:end_at]
        validate_datetimes
      end

      def label
        "#{start_at.try(:strftime, '%Y-%m-%d %H:%M')} ... #{end_at.try(:strftime, '%Y-%m-%d %H:%M')}"
      end

      def to_h
        { start_at: start_at, end_at: end_at }
      end

      private

      def validate_datetimes
        raise "expecting datetimes" unless start_at && end_at && start_at.is_a?(DateTime) && end_at.is_a?(DateTime)
      end
    end

  end
end
