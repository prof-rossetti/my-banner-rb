module MyBanner
  class Scheduler

    def initialize # (section)
      @sections ||= Page.new.scheduled_sections # consider only operating on one section at a time
    end

    def execute
      sections.map do |section|
        calendar = find_or_create_calendar_by_name(section.calendar_name)
        events = upcoming_events(calendar.id)
        events.each do |event|
          start_at = event.start.date || event.start.date_time # consider initializing via GoogleCalendarEvent wrapper class
          end_at = event.end.date || event.end.date_time # consider initializing via GoogleCalendarEvent wrapper class
          puts " + #{event.summary} [#{start_at.to_s} ... #{end_at.to_s}]"
        end
      end
    end

    def find_or_create_calendar_by_name(calendar_name)
      find_calendar_by_name(calendar_name) || create_calendar_by_name(calendar_name)
    end

    def find_calendar_by_name(calendar_name)
      calendars.find{ |cal| cal.summary == calendar_name }
    end

    def create_calendar_by_name(calendar_name)
      client.insert_calendar(new_calendar(calendar_name))
    end

    def new_calendar(calendar_name)
      cal_attrs = {summary: calendar_name, time_zone: "America/New_York"} # see: https://developers.google.com/calendar/v3/reference/calendars/insert
      Google::Apis::CalendarV3::Calendar.new(cal_attrs)
    end

    def calendars
      @calendars ||= calendars_response.items.sort_by { |cal| cal.summary }
    end

    def calendars_response
      @response ||= client.list_calendar_lists
    end

    def client
      @client ||= GoogleCalendarAPI.new.client
    end

    def upcoming_events(calendar_id="primary")
      options = { max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601 }
      upcoming_events_response = client.list_events(calendar_id, options)
      upcoming_events_response.items # upcoming_events_response(calendar_id).items
    end

    #def upcoming_events_response(calendar_id)
    #  client.list_events(calendar_id, { max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601 } )
    #end
  end
end
