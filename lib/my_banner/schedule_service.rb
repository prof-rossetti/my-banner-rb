module MyBanner
  class ScheduleService

    attr_accessor :section, :calendar_name, :client

    def initialize(section)
      @section = section
      @calendar_name = section.try(:calendar_name)
      @client = GoogleCalendarAPI.new.client
    end

    def execute
      events.each do |event|
        start_at = event.start.date || event.start.date_time
        end_at = event.end.date || event.end.date_time
        puts " + #{event.summary} [#{start_at.to_s} ... #{end_at.to_s}]"
      end
    end

    def events
      @events ||= list_events.items # .map { |item| Event.new(item) }
    end

    def calendar
      @calendar ||= (find_calendar || create_calendar)
    end

    def calendars
      @calendars ||= list_calendars.items.sort_by { |cal| cal.summary } # .map { |item| Calendar.new(item) }
    end

    private

    def list_events
      client.list_events(calendar.id, {
        max_results: 10,
        single_events: true,
        order_by: "startTime",
        time_min: Time.now.iso8601
      } )
    end

    def list_calendars
      client.list_calendar_lists
    end

    def find_calendar
      calendars.find{ |cal| cal.summary == calendar_name }
    end

    def create_calendar
      client.insert_calendar(new_calendar)
    end

    def new_calendar
      Google::Apis::CalendarV3::Calendar.new(calendar_attributes)
    end

    # @see https://developers.google.com/calendar/v3/reference/calendars/insert
    def calendar_attributes
      {summary: calendar_name, time_zone: "America/New_York"}
    end

  end
end
