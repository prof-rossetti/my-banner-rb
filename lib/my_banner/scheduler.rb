module MyBanner
  class Scheduler

    attr_accessor :section, :client

    def initialize(section)
      @section = section
      @client ||= GoogleCalendarAPI.new.client
    end

    def execute
      events.each do |event|
        start_at = event.start.date || event.start.date_time
        end_at = event.end.date || event.end.date_time
        puts " + #{event.summary} [#{start_at.to_s} ... #{end_at.to_s}]"
      end
    end

    def events
      @events ||= events_response.items # .map { |item| GoogleCalendarEvent.new(item) }
    end

    def events_response
      @events_response ||= client.list_events(calendar.id, {
        max_results: 10,
        single_events: true,
        order_by: "startTime",
        time_min: Time.now.iso8601
      } )
    end

    def calendar
      @calendar ||= find_or_create_calendar_by_name(section.calendar_name)
    end

    def find_or_create_calendar_by_name(calendar_name)
      find_calendar_by_name(calendar_name) || create_calendar_by_name(calendar_name)
    end

    def find_calendar_by_name(calendar_name)
      calendars.find{ |cal| cal.summary == calendar_name }
    end

    def calendars
      @calendars ||= calendars_response.items.sort_by { |cal| cal.summary }
    end

    def calendars_response
      @calendars_response ||= client.list_calendar_lists
    end

    def create_calendar_by_name(calendar_name)
      client.insert_calendar(new_calendar(calendar_name))
    end

    def new_calendar(calendar_name)
      cal_attrs = {summary: calendar_name, time_zone: "America/New_York"} # see: https://developers.google.com/calendar/v3/reference/calendars/insert
      Google::Apis::CalendarV3::Calendar.new(cal_attrs)
    end

  end
end
