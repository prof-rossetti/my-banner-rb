FactoryBot.define do

  factory :section, class: MyBanner::Section do
    skip_create
    initialize_with { new(attributes) }

    transient do
      meeting_times { {
        type: "Lecture",
        time: "11:00 am - 12:20 pm",
        days: "TR",
        where: "Science Building 111",
        date_range: "Oct 29, 2018 - Dec 18, 2018",
        schedule_type: "Lecture",
        instructors: ["Polly Professor"]
      } }
    end

    title { "Intro to Programming" }
    crn { 123456 } # sequence(:crn) { |n| "crn-#{n}"}
    course { "INFO 101" }
    section { 20 } # sequence(:section) { |n| 20 + n }
    status { "OPEN" }
    registration { "May 01, 2018 - Nov 02, 2018" }
    college { "School of Business and Technology" }
    department { "Information Systems" }
    part_of_term { "C04" }
    credits { 1.500 }
    levels { ["Graduate", "Juris Doctor", "Undergraduate"] }
    campus { "Main Campus" }
    override { "No" }
    enrollment_counts { { maximum: 50, actual: 45, remaining: 5 } }
    scheduled_meeting_times { meeting_times }

    factory :advanced_section do
      title { "Advanced Programming" }
      crn { 23456 }
      course{ "INFO 220" }
      section { 40 }
      scheduled_meeting_times { meeting_times.merge({ days: "MW" }) }
    end

    factory :evening_section do
      crn { 345678 }
      section { 21 }
      scheduled_meeting_times { meeting_times.merge({ days: "M", time: "6:30 pm - 9:20 pm" }) }
    end

  end

end
