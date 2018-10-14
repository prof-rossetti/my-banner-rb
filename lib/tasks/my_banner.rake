require_relative "../my_banner"

# namespace :my_banner do

  # @example rake schedule_service
  task :schedule_service do
    sections = MyBanner::Page.new.scheduled_sections
    puts "---------------------------------"
    puts "SCHEDULED SECTIONS (#{sections.count}):"
    sections.each do |section|
      puts " + #{section.abbreviation}"

      service = MyBanner::ScheduleService.new(section)

      calendar = service.calendar
      puts "   ... CALENDAR: #{calendar.summary} (#{calendar.id})"

      events = service.events
      puts "   ... UPCOMING EVENTS (#{events.count}): "
      events.each do |event|
        start_at = event.start.date || event.start.date_time #> Google::Apis::CalendarV3::EventDateTime
        end_at = event.end.date || event.end.date_time #> Google::Apis::CalendarV3::EventDateTime
        puts "   ...  + #{event.summary} (#{start_at.to_s} to #{end_at.to_s})"
      end

    end

  end

#end
