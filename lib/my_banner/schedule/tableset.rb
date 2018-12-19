module MyBanner
  class Schedule::Tableset

    attr_reader :info_table, :enrollment_table, :schedule_table

    def initialize(info_table, enrollment_table, schedule_table)
      @info_table = info_table
      @enrollment_table = enrollment_table
      @schedule_table = schedule_table
    end

    def section
      @section ||= Section.new(metadata)
    end

    def metadata
      @metadata ||= info.merge(enrollment_counts: enrollment_counts, scheduled_meeting_times: scheduled_meeting_times)
    end

    def info
      @info ||= {
        title: info_link_text[0],
        crn: info_link_text[1],
        course: info_link_text[2],
        section: info_link_text[3].to_i,
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
      @enrollment_counts ||= {
        maximum: enrollment_data[0].text.to_i,
        actual: enrollment_data[1].text.to_i,
        remaining: enrollment_data[2].text.to_i
      }
    end

    def scheduled_meeting_times
      {
        type: schedule_data[0].text,
        time: schedule_data[1].text,
        days: schedule_data[2].text,
        where: schedule_data[3].text,
        date_range: schedule_data[4].text,
        schedule_type: schedule_data[5].text,
        instructors: schedule_data[6].text.squish.split(",")
      }
    end

    private

    def info_link_text
      @info_link_text ||= info_rows[0].css("a").first.text.split("Status:").first.squish.split(" - ")
    end

    def enrollment_data
      @enrollment_data ||= begin
        enrollment_row = enrollment_rows[1]
        raise "Unexpected enrollment table row" unless enrollment_row.css("th").text == "Enrollment:"
        raise "Unexpected enrollment table data" unless enrollment_row.css("td").count == 3
        enrollment_row.css("td")
      end
    end

    def schedule_data
      @schedule_data ||= begin
        schedule_row = schedule_rows[1]
        raise "Unexpected schedule table data" unless schedule_row.css("td").count == 7 # schedule_table_headers.count
        schedule_data = schedule_row.css("td")
      end
    end

    def info_rows
      @info_rows ||= begin
        table = Nokogiri::XML(info_table.to_html) #> workaround because info_table.css("tr") seems to return too many rows (52). the raw html looks good though.
        table_rows = table.css("tr")
        raise "Unexpected number of info table rows: #{table_rows.count}" unless table_rows.count == 12
        table_rows
      end
    end

    def enrollment_rows
      @enrollment_rows ||= begin
        table_rows = enrollment_table.css("tr")
        raise "Unexpected enrollment table row count: #{table_rows.count}" unless table_rows.count == 3
        expected_headers = ["", "Maximum", "Actual", "Remaining"]
        table_headers = table_rows[0].css("th").map(&:text)
        raise "Unexpected enrollment table headers" unless table_headers == expected_headers
        table_rows
      end
    end

    def schedule_rows
      @schedule_rows ||= begin
        table = Nokogiri::XML(schedule_table.to_html)#> workaround because schedule_table.css("tr") seems to return too many rows (71). the raw html looks good though.
        table_rows = table.css("tr")
        raise "Unexpected schedule table row count: #{table_rows.count}" unless table_rows.count == 2
        # consider also validating table caption == "Scheduled Meeting Times"
        expected_headers = ["Type", "Time", "Days", "Where", "Date Range", "Schedule Type", "Instructors"]
        table_headers = table_rows[0].css("th").map(&:text)
        raise "Unexpected schedule table headers" unless table_headers == expected_headers
        table_rows
      end
    end

  end
end
