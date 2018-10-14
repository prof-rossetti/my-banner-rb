require_relative "../my_banner"

# namespace :my_banner do

  # @example bundle exec rake schedule_service
  task :schedule_service do

    sections = MyBanner::Page.new.scheduled_sections
    puts "-----------------------"
    puts "SECTIONS: #{sections.count}"
    puts "-----------------------"

    sections.each do |section|
      puts "SECTION: #{section.abbreviation} / #{section.title}"

      service = MyBanner::ScheduleService.new(section)
      calendar = service.calendar
      puts "CALENDAR: #{calendar.summary} / #{calendar.id}"

      events = service.events
      puts "EVENTS: #{events.count}"
      #events.each do |event|
      #  start_at = event.start.date || event.start.date_time #> Google::Apis::CalendarV3::EventDateTime
      #  end_at = event.end.date || event.end.date_time #> Google::Apis::CalendarV3::EventDateTime
      #  puts "  + #{event.summary} [#{start_at.to_s} ... #{end_at.to_s}]"
      #end

      meetings = section.meetings
      puts "MEETINGS: #{meetings.count}"
      #meetings.each do |meeting|
      #  puts "  + #{meeting[:start_at].to_date.to_s} [#{meeting[:start_at].strftime("%H:%M")} ... #{meeting[:end_at].strftime("%H:%M")}]"
      #  #binding.pry
      #end

      service.execute

      puts "-----------------------"
    end
  end

#end
