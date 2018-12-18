module MyBanner
  class FacultyDetailSchedule::Tableset

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
      info_rows = info_table.css("tr")
      #raise "Unexpected number of info table rows: #{info_rows.count}" unless info_rows.count == 12
      #binding.pry
      {
        title: "Intro to Programming",
        crn: 123456,
        course: "INFO 101",
        section: 20,
        status: "OPEN",
        registration: "May 01, 2018 - Nov 02, 2018",
        college: "School of Business and Technology",
        department: "Information Systems",
        part_of_term: "C04",
        credits: 1.5,
        levels: ["Graduate", "Juris Doctor", "Undergraduate"],
        campus: "Main Campus",
        override: "No"
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
      schedule_rows = schedule_table.css("tr")
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
