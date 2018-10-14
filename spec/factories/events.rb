FactoryBot.define do

  factory :event, class: Google::Apis::CalendarV3::Event do
    skip_create
    initialize_with { new(attributes) }

    transient do
      uuid { |n| "abc-#{n}" }
    end

    id { uuid }
    etag { "\"abc123def456xyz789\"" }
    html_link { "https://www.google.com/calendar/event?eid=92929fhfhfh#" }
    i_cal_uid { "#{uuid}@google.com" }
    summary { "My Lunch Event" }
    add_attribute(:start) { {date_time: "2018-10-17T12:00:00-04:00".to_datetime } }
    add_attribute(:end) { { date_time: "2018-10-17T13:30:00-04:00".to_datetime } }

    factory :all_day_event do
      summary { "My All-day Event" }
      add_attribute(:start) { { date: "2018-10-16" } }
      add_attribute(:end) { { date: "2018-10-17" } }
    end
  end

end
