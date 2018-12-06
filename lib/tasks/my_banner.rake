require_relative "../my_banner"

# namespace :my_banner do

  # @example bundle exec rake create_calendars
  task :create_calendars do
    sections = MyBanner::Page.new.scheduled_sections
    puts "-----------------------"
    puts "SECTIONS: #{sections.count}"
    puts "-----------------------"
    sections.each do |section|
      puts "\nSECTION: #{section.abbreviation} (#{section.title})"
      service = MyBanner::CalendarService.new(section)

      calendar = service.calendar
      puts "\nCALENDAR: #{calendar.summary} (#{calendar.id})"

      meetings = section.meetings
      puts "\nMEETINGS: #{meetings.count}"
      meetings.each do |meeting|
        puts " + #{meeting[:start_at].strftime('%Y-%m-%d %H:%M')} ... #{meeting[:end_at].strftime('%Y-%m-%d %H:%M')}"
      end

      events = service.events
      puts "\nFUTURE EVENTS: #{events.count}"
      events.each do |event|
        event_start = event.start.date_time.try(:strftime, "%Y-%m-%d %H:%M") || event.start.date.try(:strftime, "%Y-%m-%d")
        event_end = event.end.date_time.try(:strftime, "%Y-%m-%d %H:%M") || event.end.date.try(:strftime, "%Y-%m-%d")
        puts " + #{event_start} ... #{event_end} (#{event.class})"
      end

      service.execute
      puts "\n-----------------------"
    end
  end

  # @example bundle exec rake clear_calendars
  task :clear_calendars do
    sections = MyBanner::Page.new.scheduled_sections
    sections.each do |section|
      service = MyBanner::CalendarService.new(section)
      service.send(:delete_events)
    end
  end

#end
