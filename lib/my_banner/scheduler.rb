module MyBanner
  class Scheduler

    def execute
      #puts "PARSING SCHEDULE PAGE..."
      #puts "CREATING GOOGLE CALENDAR EVENTS..."

      calendar_id = 'primary'
      request_options = {max_results: 10, single_events: true, order_by: 'startTime', time_min: Time.now.iso8601}

      response = client.list_events(calendar_id, request_options)
      puts "RESPONSE"
      puts response

      events = response.items
      puts "UPCOMING EVENTS (#{events.count}): "
      events.each do |event|
        start = event.start.date || event.start.date_time
        puts "- #{event.summary} (#{start})"
      end

      true
    end

    def client
      @client ||= GoogleCalendarAPI.new.client
    end

    #def page
    #  @page ||= Page.new
    #end

  end
end
