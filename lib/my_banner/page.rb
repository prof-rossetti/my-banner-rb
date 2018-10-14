module MyBanner
  class Page

    def parse
      scheduled_sections
    end

    def scheduled_sections
      [ section_attributes, section2_attributes, section3_attributes ].map { |h| MyBanner::Section.new(h) }
    end # todo: parse the HTML page

    def section_attributes
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
        credits: 1.500,
        levels: ["Graduate", "Juris Doctor", "Undergraduate"],
        campus: "Main Campus",
        override: "No",
        enrollment_counts: {maximum: 50, actual: 45, remaining: 5},
        scheduled_meeting_times: {
          type: "Lecture",
          time: "11:00 am - 12:20 pm",
          days: "TR",
          where: "Science Building 111",
          date_range: "Oct 29, 2018 - Dec 18, 2018",
          schedule_type: "Lecture",
          instructors: ["Polly Professor"]
        }
      }
    end

    def section2_attributes
      section_attributes.merge({
        title: "Advanced Programming",
        crn: 23456,
        course: "INFO 220",
        section: 40,
        scheduled_meeting_times: meeting_times.merge(days: "MW")
      })
    end

    def section3_attributes
      section_attributes.merge({
        title: "Advanced Programming",
        crn: 345678,
        course: "INFO 220",
        section: 41,
        scheduled_meeting_times: meeting_times.merge(time: "6:30 pm - 9:20 pm", days: "M")
      })
    end

  end
end
