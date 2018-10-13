require_relative "../my_banner"

# namespace :my_banner do

  task :schedule do
    service = MyBanner::Scheduler.new
    sections = service.sections

    puts "---------------------------------"
    puts "SCHEDULED SECTIONS (#{sections.count}):"
    sections.each do |section|
      puts " + #{section.abbreviation}"

      calendar = service.find_or_create_calendar_by_name(section.calendar_name)
      puts "   ... CALENDAR: #{calendar.id} (#{calendar.summary})"

      events = service.upcoming_events(calendar.id)
      puts "   ... UPCOMING EVENTS (#{events.count}): "
      events.each do |event|
        start_at = event.start.date || event.start.date_time #> Google::Apis::CalendarV3::EventDateTime
        end_at = event.end.date || event.end.date_time #> Google::Apis::CalendarV3::EventDateTime
        puts "   ... + #{event.summary} (#{start_at.to_s} to #{end_at.to_s})"
      end
    end

  end

#end
