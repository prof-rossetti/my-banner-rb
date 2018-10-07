module MyBanner
  class Scheduler

    def execute
      puts "---------------------------------"
      puts "SCHEDULED SECTIONS (#{sections.count}):"
      sections.each do |section|
        puts " + #{section.abbreviation}"
      end

      puts "---------------------------------"
      puts "CALENDARS (#{calendars.count}):"
      calendars.each do |calendar|
        puts " + #{calendar.id} (#{calendar.summary})"
      end

      puts "---------------------------------"
      puts "FINDING OR CREATING CALENDARS:"
      sections.each do |section|
        calendar = find_or_create_calendar_by_name(section.calendar_name)
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

    def response
      @response ||= client.list_calendar_lists
    end

    def find_or_create_calendar_by_name(calendar_name)
      calendar = calendars.find{|cal| cal.summary == calendar_name }

      if calendar
        puts " + FOUND CALENDAR #{calendar.summary}"
      else
        calendar = Google::Apis::CalendarV3::Calendar.new(summary: calendar_name, time_zone: 'America/New_York')
        result = client.insert_calendar(calendar)
        puts " + CREATED CALENDAR #{calendar.summary}"
      end

      calendar
    end

    #def upcoming_events(calendar_id="primary")
    #  response = client.list_events(calendar_id, {max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601})
    #  events = response.items
    #  #puts "CALENDAR: #{}"
    #  puts "UPCOMING EVENTS (#{events.count}): "
    #  events.each do |event|
    #    start_at = event.start.date || event.start.date_time
    #    end_at = event.end.date || event.end.date_time
    #    puts " + #{event.summary} (#{start_at} to #{end_at})"
    #  end
    #  events
    #end

  end
end
