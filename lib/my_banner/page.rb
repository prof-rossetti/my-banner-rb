module MyBanner
  class Page

    def parse
      metadata
    end

    # some mock metadata until page-parsing is implemented
    def metadata
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
          days: "MW",
          where: "Science Building 111",
          date_range: "Oct 29, 2018 - Dec 18, 2018",
          schedule_type: "Lecture",
          instructors: ["Polly Professor"]
        }
      }
    end

  end
end
