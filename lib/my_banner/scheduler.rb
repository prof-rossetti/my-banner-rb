module MyBanner
  class Scheduler
    attr_reader :client, :page, :sections

    def initialize
      @client = GoogleCalendarAPI.new.client
      @page = Page.new
      @sections = page.scheduled_sections
    end

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
    end

    def calendars
      @calendars ||= client.list_calendar_lists.items.sort_by { |cal| cal.summary }
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
