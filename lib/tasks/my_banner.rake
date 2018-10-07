require_relative "../my_banner"

# namespace :my_banner do

  task :schedule do
    puts "---------------------------------"
    puts "SCHEDULING..."

    service = MyBanner::Scheduler.new
    sections = service.sections
    calendars = service.calendars

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

    puts "---------------------------------"
    puts "FINDING OR CREATING CALENDARS:"
    #service.execute

  end

#end


