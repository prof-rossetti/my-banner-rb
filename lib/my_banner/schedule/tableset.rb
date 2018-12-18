module MyBanner
  class Schedule::Tableset

    attr_reader :info_table, :enrollment_table, :schedule_table

    def initialize(info_table, enrollment_table, schedule_table)
      @info_table = info_table
      @enrollment_table = enrollment_table
      @schedule_table = schedule_table
    end

    def section
      Section.new(metadata)
    end

    def metadata
      info.merge(enrollment_counts: enrollment_counts, scheduled_meeting_times: scheduled_meeting_times)
    end

    def info
      #> info_table.to_html looks good, but the nokogiri node includes all tables with 52 rows. WAT? trying to isolate the first table only...
      iso_table = Nokogiri::XML(info_table.to_html)
      info_rows = iso_table.css("tr")
      raise "Unexpected number of info table rows: #{info_rows.count}" unless info_rows.count == 12

      #> info_rows[0] includes all rows WAT? trying to isolate the first row only...
      link_text = info_rows[0].css("a").first.text.split("Status:").first.squish #> "Intro to Programming - 123456 - INFO 101 - 020"
      link_text = link_text.split(" - ") #> ["Intro to Programming", "123456", "INFO 101", "020"]

      {
        title: link_text[0],
        crn: link_text[1],
        course: link_text[2],
        section: link_text[3].to_i,
        status: info_rows[1].css("td").text,
        registration: info_rows[2].css("td").text,
        college: info_rows[3].css("td").text.squish,
        department: info_rows[4].css("td").text.squish,
        part_of_term: info_rows[5].css("td").text,
        credits: info_rows[6].css("td").text.squish.to_f,
        levels: info_rows[7].css("td").text.split(", "),
        campus: info_rows[8].css("td").text,
        override: info_rows[9].css("td").text
      }
    end

    def enrollment_counts
      enrollment_rows = enrollment_table.css("tr")
      raise "Unexpected enrollment table row count: #{enrollment_rows.count}" unless enrollment_rows.count == 3
      enrollment_table_headers = ["", "Maximum", "Actual", "Remaining"]
      raise "Unexpected enrollment table headers" unless enrollment_rows[0].css("th").map(&:text) == enrollment_table_headers
      enrollment_row = enrollment_rows[1]
      raise "Unexpected enrollment table row" unless enrollment_row.css("th").text == "Enrollment:"
      raise "Unexpected enrollment table data" unless enrollment_row.css("td").count == 3
      enrollment_data = enrollment_row.css("td")
      enrollment_max = enrollment_data[0].text.to_i
      enrollment_actual = enrollment_data[1].text.to_i
      enrollment_remaining = enrollment_data[2].text.to_i
      return {
        maximum: enrollment_max,
        actual: enrollment_actual,
        remaining: enrollment_remaining
      }
    end

    def scheduled_meeting_times
      # schedule table caption should be "Scheduled Meeting Times"

      #schedule_rows = schedule_table.css("tr") #> schedule_table.to_html looks good, but the nokogiri node includes 71 rows. WAT? trying to isolate the given table only...
      iso_table = Nokogiri::XML(schedule_table.to_html)
      schedule_rows = iso_table.css("tr")

      raise "Unexpected schedule table row count: #{schedule_rows.count}" unless schedule_rows.count == 2
      schedule_table_headers = ["Type", "Time", "Days", "Where", "Date Range", "Schedule Type", "Instructors"]
      raise "Unexpected schedule table headers" unless schedule_rows[0].css("th").map(&:text) == schedule_table_headers
      schedule_row = schedule_rows[1]
      raise "Unexpected schedule table data" unless schedule_row.css("td").count == 7 # schedule_table_headers.count
      schedule_data = schedule_row.css("td")

      return {
        type: schedule_data[0].text,
        time: schedule_data[1].text,
        days: schedule_data[2].text,
        where: schedule_data[3].text,
        date_range: schedule_data[4].text,
        schedule_type: schedule_data[5].text,
        instructors: schedule_data[6].text.squish.split(",")
      }
    end

  end
end
