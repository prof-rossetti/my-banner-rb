module MyBanner
  class CalendarService

    attr_accessor :section, :calendar_name, :time_zone, :location, :meetings

    def initialize(section)
      @section = section
      @calendar_name = section.calendar_name
      @time_zone = section.time_zone
      @location = section.location
      @meetings = section.meetings # todo: exclude meetings cancelled/rescheduled due to holidays
    end

    def execute
      meetings.map do |meeting|
        event = find_event(meeting.to_h)
        event ? update_event(event, meeting.to_h) : create_event(meeting.to_h)
      end
    end

    def events
      @events ||= list_events.items
    end

    def calendar
      @calendar ||= (find_calendar || create_calendar)
    end

    def calendars
      @calendars ||= list_calendars.items.sort_by { |cal| cal.summary }
    end

    def client
      @client = CalendarClient.new
    end

    private

    #
    # EVENT OPERATIONS
    #

    def delete_events
      events.map { |event| client.delete_event(calendar.id, event.id) }
    end

    def list_events
      client.list_events(calendar.id, {
        max_results: 100,
        single_events: true,
        order_by: "startTime",
        time_min: Time.now.iso8601,
        show_deleted: false
      } )
    end

    def update_event(event, meeting_attrs)
      client.update_event(calendar.id, event.id, new_event(meeting_attrs))
    end

    def find_event(meeting_attrs)
      events.find do |e|
        # match datetime events
        (
          e.start.date_time.try(:strftime, "%Y-%m-%dT%H:%M:%S") == meeting_attrs[:start_at].try(:strftime, "%Y-%m-%dT%H:%M:%S") &&
          e.end.date_time.try(:strftime, "%Y-%m-%dT%H:%M:%S") == meeting_attrs[:end_at].try(:strftime, "%Y-%m-%dT%H:%M:%S")
        ) ||
        # match date events
        (
          e.start.date.try(:strftime, "%Y-%m-%dT%H:%M:%S") == meeting_attrs[:start_at].try(:strftime, "%Y-%m-%dT%H:%M:%S") &&
          e.end.date.try(:strftime, "%Y-%m-%dT%H:%M:%S") == meeting_attrs[:end_at].try(:strftime, "%Y-%m-%dT%H:%M:%S")
        )
      end
    end

    def create_event(meeting_attrs)
      client.insert_event(calendar.id, new_event(meeting_attrs))
    end

    def new_event(meeting_attrs)
      Google::Apis::CalendarV3::Event.new(event_attributes(meeting_attrs))
    end

    def event_attributes(meeting_attrs)
      {
        summary: calendar_name,
        location: location,
        start: {
          date_time: meeting_attrs[:start_at].strftime("%Y-%m-%-dT%H:%M:%S"), # excludes offset, regardless of tz presence, to avoid maladjustment
          time_zone: time_zone
        },
        end: {
          date_time: meeting_attrs[:end_at].strftime("%Y-%m-%-dT%H:%M:%S"), # excludes offset, regardless of tz presence, to avoid maladjustment
          time_zone: time_zone
        },
        # description: "Agenda: https://.../units/1 \n \n Objectives: \n 1: ....  \n 2: ....  \n 3: ....", # todo
        # attendees: ["hello@gmail.com", "prof@my-school.edu", "student@my-school.edu"],
        # source: {title: "External link", url: "https://.../units/1"}
      }
    end

    #
    # CALENDAR OPERATIONS
    #

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

    def calendar_attributes
      {summary: calendar_name, time_zone: time_zone}
    end

  end
end
