module MyBanner
  class Scheduler

    def execute
      sections.each do |section|
        calendar = find_or_create_calendar_by_name(section.calendar_name)
        events = upcoming_events(calendar.id)
        #binding.pry
      end
    end

    def sections
      @sections ||= page.scheduled_sections
    end

    def page
      @page ||= Page.new
    end

    def client
      @client ||= GoogleCalendarAPI.new.client
    end

    def calendars
      @calendars ||= response.items.sort_by { |cal| cal.summary }
    end

    def response # calendars_response
      @response ||= client.list_calendar_lists
    end

    def find_or_create_calendar_by_name(calendar_name)
      calendar = calendars.find{|cal| cal.summary == calendar_name }
      calendar = client.insert_calendar(new_calendar(calendar_name)) unless calendar
      calendar
    end

    def new_calendar(calendar_name)
      Google::Apis::CalendarV3::Calendar.new(
        summary: calendar_name,
        time_zone: "America/New_York" #,
        #color_id: "...",
        #foreground_color: "",
        #background_color: ""
      )
    end

    def upcoming_events(calendar_id="primary")
      #upcoming_events_response(calendar_id).items
      upcoming_events_response = client.list_events(calendar_id, { max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601 } )
      upcoming_events_response.items
    end

    #def upcoming_events_response(calendar_id)
    #  client.list_events(calendar_id, { max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601 } )
    #end
  end
end
