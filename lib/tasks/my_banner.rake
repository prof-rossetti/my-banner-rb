require_relative "../my_banner"

# namespace :my_banner do

  task :parse_schedule do
    page = MyBanner::Schedule.new
    sections = page.sections
    puts "-----------------------"
    puts "SECTIONS: #{sections.count}"
    puts "-----------------------"
    sections.each do |section|
      puts ""
      puts "#{section.title.upcase}:"
      puts ""
      pp section.metadata
      puts ""
    end
  end

  # @example bundle exec rake create_calendars
  task :create_calendars do
    page = MyBanner::Schedule.new
    sections = page.sections
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
        puts " + #{meeting.to_s}"
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
    page = MyBanner::Schedule.new
    sections = page.sections
    sections.each do |section|
      service = MyBanner::CalendarService.new(section)
      service.send(:delete_events)
    end
  end

  # @example bundle exec rake create_spreadsheets
  task :create_spreadsheets do
    service = MyBanner::SpreadsheetService.new

    spreadsheet = service.spreadsheet
    puts "SPREADSHEET: #{spreadsheet.properties.title.upcase}"
    puts "ID: #{spreadsheet.spreadsheet_id}"
    #puts "SHEETS:"
    #spreadsheet.sheets.each do |sheet|
    #  cols = sheet.properties.grid_properties.column_count
    #  rows = sheet.properties.grid_properties.row_count
    #  puts "  + #{sheet.properties.title} (#{cols} cols x #{rows} rows)"
    #end

    setter_response = service.execute

    puts "DATA:"
    getter_response = service.client.get_spreadsheet_values(spreadsheet.spreadsheet_id, setter_response.updated_range)
    getter_response.values.each do |row|
      puts "  #{row.join(" | ")}"
    end
  end

#end
