require_relative "../my_banner"

# namespace :my_banner do

  # @example bundle exec rake schedule_service
  task :schedule_service do

    sections = MyBanner::Page.new.scheduled_sections
    puts "-----------------------"
    puts "FETCHING CALENDARS FOR #{sections.count} SECTIONS..."
    puts "-----------------------"

    sections.each do |section|
      service = MyBanner::ScheduleService.new(section)
      calendar = service.calendar
      events = service.events
      puts "---"
      puts "ID: '#{calendar.id}'"
      puts "NAME: '#{calendar.summary}'"
      puts "EVENTS: #{events.count}"
      events.each do |event|
        start_at = event.start.date || event.start.date_time #> Google::Apis::CalendarV3::EventDateTime
        end_at = event.end.date || event.end.date_time #> Google::Apis::CalendarV3::EventDateTime
        puts "  + '#{event.summary}' [#{start_at.to_s} ... #{end_at.to_s}]"
      end
      puts "---"
    end
  end

#end
