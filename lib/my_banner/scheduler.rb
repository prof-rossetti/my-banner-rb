module MyBanner
  class Scheduler

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
      binding.pry
    end

    def client
      #@client ||= GoogleCalendarClient.new #> undefined method `list_events' for #<MyBanner::GoogleCalendarClient:0x007feda8996b30>
      @client ||= GoogleCalendarAPI.new.client #> undefined method `list_events' for #<MyBanner::GoogleCalendarClient:0x007feda8996b30>
    end

    #def page
    #  @page ||= Page.new
    #end

  end
end
