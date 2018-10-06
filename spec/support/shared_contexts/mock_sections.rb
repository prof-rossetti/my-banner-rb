shared_context "mock sections" do

  let(:mock_meeting_times) { {
    type: "Lecture",
    time: "11:00 am - 12:20 pm",
    days: "TR",
    where: "Science Building 111",
    date_range: "Oct 29, 2018 - Dec 18, 2018",
    schedule_type: "Lecture",
    instructors: ["Polly Professor"]
  } }

  let(:mock_section_metadata) { {
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
    scheduled_meeting_times: mock_meeting_times
  } }

  let(:mock_sections_metadata) { [
    mock_section_metadata,
    mock_section_metadata.merge({
      title: "Advanced Programming",
      crn: 23456,
      course: "INFO 202",
      section: 40,
      scheduled_meeting_times: mock_meeting_times.merge(days: "MW")
    }),
    mock_section_metadata.merge({
      title: "Advanced Programming",
      crn: 345678,
      course: "INFO 202",
      section: 41,
      scheduled_meeting_times: mock_meeting_times.merge(time: "6:30 pm - 9:20 pm", days: "M")
    })
  ] }

  let(:mock_sections) {
    mock_sections_metadata.map { |metadata| MyBanner::Section.new(metadata) }
  }

end
