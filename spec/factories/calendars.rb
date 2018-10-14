FactoryBot.define do

  factory :calendar, class: Google::Apis::CalendarV3::Calendar do
    skip_create
    initialize_with { new(attributes) }

    kind { "calendar#calendar" }
    sequence(:id) { |n| "cal#{n}@group.calendar.google.com" }
    summary { "Calendar #{n}" }
    time_zone { "America/New_York" }
    etag { "\"abc123def456xyz789\"" }

    #:access_role=>"reader",
    #:background_color=>"#9a9cff",
    #:color_id=>"17",
    #:conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
    #:default_reminders=>[],
    #:foreground_color=>"#000000",

  end

end
