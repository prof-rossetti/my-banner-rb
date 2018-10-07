shared_context "google calendar lists" do

  let(:calendar_list) { Google::Apis::CalendarV3::CalendarList.new(items: calendar_list_entries) }

  let(:calendar_list_entries) { [ calendar_list_entry ] }

  let(:calendar_list_entry) { Google::Apis::CalendarV3::CalendarListEntry.new(calendar_list_entry_attrs) }

  let(:calendar_list_entry_attrs) { {
    :access_role=>"reader",
    :background_color=>"#9a9cff",
    :color_id=>"17",
    :conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
    :default_reminders=>[],
    :etag=>"\"39887154084050111\"",
    :foreground_color=>"#000000",
    :id=>"#contacts@group.v.calendar.google.com",
    :kind=>"calendar#calendarListEntry",
    :summary=>"Contacts",
    :time_zone=>"America/New_York"
  } }

end
