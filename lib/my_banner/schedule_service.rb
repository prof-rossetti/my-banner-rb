module MyBanner
  class ScheduleService
    #include ActiveModel::Validations

    #validate :validate_section

    attr_accessor :section, :calendar_name, :time_zone, :meetings, :client

    def initialize(section)
      @section = section
      @calendar_name = section.calendar_name
      @time_zone = section.time_zone
      @meetings = section.meetings # todo: exclude "Holidays in the United States"
      @client = GoogleCalendarAPI.new.client
    end

    def execute
      meetings.map do |meeting|
        event = find_event(meeting)
        if event
          update_event(event, meeting)
        else
          create_event(meeting)
        end
      end
    end

    def events
      @events ||= list_events.items #.select{ |e| e.status != "cancelled" } #.sort_by { |e| e.start.date.to_i || e.start.date_time.to_i }
    end

    def calendar
      @calendar ||= (find_calendar || create_calendar)
    end

    def calendars
      @calendars ||= list_calendars.items.sort_by { |cal| cal.summary }
    end

    def clear_calendar # warning: use with caution!
      events.map do |event|
        client.delete_event(calendar.id, event.id)
      end
    end

    private

    #def validate_section
    #  errors.add(:section, "should be a Section") unless section && section.kind_of?(Section)
    #end

    #
    # EVENT SERVICE
    #

    def list_events
      client.list_events(calendar.id, {
        max_results: 100,
        single_events: true,
        order_by: "startTime",
        time_min: Time.now.iso8601,
        show_deleted: false
      } )
    end

    def update_event(event, meeting)
        #edit_attrs = event_attributes(meeting)
        #event.summary = edit_attrs[:summary]
        #event.location = edit_attrs[:location]
        #event.description = edit_attrs[:description]
        ## don't update start and end times, because those comprise a composite key used for uniquely identifying the meeting's event
        ## consider metaprogramming these ...
        ##edit_attrs.keys.reject_if?{ |k| [:start, :end].includes?(k) }.each do |k|
        ##  event.send(k) = edit_attrs[k]
        ##end
        #result = client.update_event(calendar.id, event.id, event)

        client.update_event(calendar.id, event.id, new_event(meeting))
    end

    def find_event(meeting)
      events.find do |e|
        (e.start.date_time == meeting[:start_at].to_s && e.end.date_time == meeting[:end_at].to_s) ||
        (e.start.date == meeting[:start_at].to_s && e.end.date == meeting[:end_at].to_s)
      end
    end

    def create_event(meeting)
      client.insert_event(calendar.id, new_event(meeting))
    end

    def new_event(meeting)
      Google::Apis::CalendarV3::Event.new(event_attributes(meeting))
    end

    # @see https://developers.google.com/calendar/v3/reference/events/insert
    # @param meeting [Hash]
    # @param meeting [Hash] start_at [DateTime]
    # @param meeting [Hash] end_at [DateTime]
    def event_attributes(meeting)
      {
        summary: "Unit 1A", # todo: variable / units counter
        location: section.location,
        start: { date_time: meeting[:start_at].to_s, time_zone: time_zone },
        end: { date_time: meeting[:end_at].to_s, time_zone: time_zone },
        description: "Agenda: https://.../units/1 \n \n Objectives: \n 1: ....  \n 2: ....  \n 3: ....", # todo
        #attendees: ["hello@gmail.com", "prof@my-school.edu", "student@my-school.edu"],
        source: {title: "External link", url: "https://.../units/1"}
      } # example '2015-05-28T09:00:00-07:00' ... '2015-05-28T17:00:00-07:00'
    end

    #
    # CALENDAR SERVICE
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

    # @see https://developers.google.com/calendar/v3/reference/calendars/insert
    def calendar_attributes
      {summary: calendar_name, time_zone: "America/New_York"}
    end

  end
end
