require "active_support/core_ext/string/conversions"

shared_context "google calendar events" do

  let(:calendar_events) { Google::Apis::CalendarV3::Events.new(items: [ all_day_event, lunch_event ] ) }

  let(:all_day_event) { Google::Apis::CalendarV3::Event.new(all_day_event_attrs) }

  let(:lunch_event) { Google::Apis::CalendarV3::Event.new(lunch_event_attrs) }

  let(:all_day_event_attrs) { {
    #:created=>#<DateTime: 2018-10-07T20:16:23+00:00 ((2458399j,72983s,0n),+0s,2299161j)>,
    #:creator=>{:email=>"polly.prof@gmail.com"},
    :end=>{:date=>"2018-10-17"},
    #:etag=>"\"3077886767628000\"",
    #:extended_properties=>{:private=>{:everyoneDeclinedDismissed=>"-1"}},
    #:html_link=>"https://www.google.com/calendar/event?eid=1615dfdfllpap",
    #:i_cal_uid=>"abc123@google.com",
    #:id=>"abc123",
    #:kind=>"calendar#event",
    #:organizer=>{:display_name=>"INFO 101-20", :email=>"lmn9876@group.calendar.google.com", :self=>true},
    #:reminders=>{:use_default=>true},
    #:sequence=>0,
    :start=>{:date=>"2018-10-16"},
    #:status=>"confirmed",
    :summary=>"My Day-long Event",
    #:transparency=>"transparent",
    #:updated=>#<DateTime: 2018-10-07T20:16:23+00:00 ((2458399j,72983s,814000000n),+0s,2299161j)>}
  } }

  let(:lunch_event) { {
    #:created=>#<DateTime: 2018-10-07T20:15:09+00:00 ((2458399j,72909s,0n),+0s,2299161j)>,
    #:creator=>{:email=>"polly.prof@gmail.com"},

    #:end=>{:date_time=>#<DateTime: 2018-10-17T13:30:00-04:00 ((2458409j,63000s,0n),-14400s,2299161j)>},
    :end=>{:date_time=> "2018-10-17T12:00:00-04:00".to_datetime },

    #:etag=>"\"3077886767628000\"",
    #:extended_properties=>{:private=>{:everyoneDeclinedDismissed=>"-1"}},
    #:html_link=>"https://www.google.com/calendar/event?eid=92929fhfhfh",
    #:i_cal_uid=>"def456@google.com",
    #:id=>"def456",
    #:kind=>"calendar#event",
    #:organizer=>{:display_name=>"INFO 101-20", :email=>"lmn9876@group.calendar.google.com", :self=>true},
    #:reminders=>{:use_default=>true},
    #:sequence=>0,

    #:start=>{:date_time=>#<DateTime: 2018-10-17T12:00:00-04:00 ((2458409j,57600s,0n),-14400s,2299161j)>},
    :start=>{:date_time=> "2018-10-17T13:30:00-04:00".to_datetime},

    #:status=>"confirmed",
    :summary=>"My Lunch Event",
    #:transparency=>"transparent",
    #:updated=>#<DateTime: 2018-10-07T20:53:24+00:00 ((2458399j,75204s,60000000n),+0s,2299161j)>
  } }

end


# expect event.start.date_time.to_s to eql "2018-10-17T12:00:00-04:00"
# expect event.end.date_time.to_s to eql "2018-10-17T13:30:00-04:00"

# expect "2018-10-17T12:00:00-04:00".to_datetime to eql event.start.date_time
# expect "2018-10-17T13:30:00-04:00".to_datetime to eql event.end.date_time
