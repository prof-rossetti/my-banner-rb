module MyBanner
  class Scheduler
    attr_reader :client, :page

    def initialize
      @client = GoogleCalendarAPI.new.client
      @page = Page.new
    end

    def execute
      scheduled_sections = [{name: "INFO 101-20"}, {name: "INFO 101-40"}, {name: "INFO 101-41"}]
      puts "SCHEDULED SECTIONS (#{scheduled_sections.count}):"
      scheduled_sections.each do |section|
        puts " + #{section[:name]}"
        puts "    ... FIND OR CREATE CALENDAR BY NAME"
        puts "    ... LIST ALL UPCOMING EVENTS ON THAT CALENDAR"
      end
    end

    def upcoming_events(calendar_id="primary")
      response = client.list_events(calendar_id, {max_results: 10, single_events: true, order_by: "startTime", time_min: Time.now.iso8601})
      events = response.items
      #puts "CALENDAR: #{}"
      puts "UPCOMING EVENTS (#{events.count}): "
      events.each do |event|
        start_at = event.start.date || event.start.date_time
        end_at = event.end.date || event.end.date_time
        puts " + #{event.summary} (#{start_at} to #{end_at})"
      end
      events
    end

    def calendars
      response = client.list_calendar_lists
      cals = response.items
      puts "CALENDARS (#{cals.count}):"
      cals.sort_by! { |cal| cal.summary }
      cals.each do |cal|
        puts " + #{ {name: cal.summary, id: cal.id} }"
      end
      cals
    end

  end
end
