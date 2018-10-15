require_relative "../my_banner"

# namespace :my_banner do

  # @example bundle exec rake schedule_events
  task :schedule_events do
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
      meetings = section.meetings
      puts "MEETINGS: #{meetings.count}"
      service.execute
      puts "-----------------------"
    end
  end

  # @example bundle exec rake clear_calendars
  task :clear_calendars do
    sections = MyBanner::Page.new.scheduled_sections
    sections.each do |section|
      service = MyBanner::ScheduleService.new(section)
      service.clear_calendar
    end
  end

#end
