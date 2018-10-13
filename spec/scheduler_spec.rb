module MyBanner
  RSpec.describe Scheduler do
    include_context "sections"
    include_context "google calendar lists"
    include_context "google calendar events"

    let(:service) { described_class.new }

    let(:client) { instance_double(Google::Apis::CalendarV3::CalendarService,
      list_calendar_lists: nil,
      insert_calendar: nil,
      list_events: nil
    ) }

    describe "#execute" do
      let(:calendar) { Google::Apis::CalendarV3::Calendar.new(
        summary: "My Class 1",
        time_zone: "America/New_York",
        etag: "\"...\"",
        id: "myclass1@group.calendar.google.com",
        kind: "calendar#calendar"
      ) }
      let(:calendar2) { Google::Apis::CalendarV3::Calendar.new(
        summary: "My Class 2",
        time_zone: "America/New_York",
        etag: "\"...\"",
        id: "myclass2@group.calendar.google.com",
        kind: "calendar#calendar"
      ) }
      let(:calendar3) { Google::Apis::CalendarV3::Calendar.new(
        summary: "My Class 3",
        time_zone: "America/New_York",
        etag: "\"...\"",
        id: "myclass3@group.calendar.google.com",
        kind: "calendar#calendar"
      ) }

      before(:each) do
        allow(client).to receive(:list_events).and_return([]) # calendar_events
        allow(client).to receive(:insert_calendar).and_return(calendar) # , calendar2, calendar3
        allow(service).to receive(:client).and_return(client)
        allow(service).to receive(:sections).and_return(sections)
        allow(service).to receive(:calendars).and_return([])
        allow(service).to receive(:upcoming_events).with(calendar.id).and_return(calendar_events)
        #allow(service).to receive(:upcoming_events).with(calendar2.id).and_return([])
        #allow(service).to receive(:upcoming_events).with(calendar3.id).and_return([])
      end

      it "fetches sections" do
        expect(service).to receive(:sections).and_return(sections).at_least(:once)
        service.execute
      end

      it "finds or creates section calendars" do
        expect(service).to receive(:find_or_create_calendar_by_name).exactly(3).times.and_return(calendar, calendar, calendar) # , calendar2, calendar3
        service.execute
      end

      #it "creates google calendar events" do
      #  expect(service.execute).to eql(true)
      #end
    end

    describe "#calendars" do
      before(:each) do
        allow(service).to receive(:calendars_response).and_return(calendar_list)
      end

      it "lists and sorts my calendars" do
        expect(service.calendars.map(&:class).uniq ).to eql( [Google::Apis::CalendarV3::CalendarListEntry] )
        expect(service.calendars.first.summary).to eql("Contacts")
      end
    end

    describe "#calendars_response" do
      before(:each) do
        allow(service).to receive(:client).and_return(client)
      end

      it "issues an api request" do
        expect(service.client).to receive(:list_calendar_lists)
        service.calendars_response
      end

      context "when successful" do
        before(:each) do
          allow(service).to receive(:calendars_response).and_return(calendar_list)
        end

        it "returns a calendar list" do
          expect(service.calendars_response.class).to eql(Google::Apis::CalendarV3::CalendarList)
          expect(service.calendars_response.items.any?).to be true
          expect(service.calendars_response.items.first.class).to eql(Google::Apis::CalendarV3::CalendarListEntry)
        end
      end
    end

    describe "#find_or_create_calendar_by_name" do
      let(:calendar_names) { service.calendars.map(&:summary) }

      before(:each) do
        allow(service).to receive(:calendars_response).and_return(calendar_list)
      end

      context "calendar exists" do
        let(:calendar_name) { "Contacts" }

        it "finds a calendar with the given name" do
          expect(calendar_names.include?(calendar_name)).to be true
          result = service.find_or_create_calendar_by_name(calendar_name)
          expect(result).to be_kind_of(Google::Apis::CalendarV3::CalendarListEntry)
          expect(result.id).to be_kind_of(String)
          expect(result.etag).to be_kind_of(String)
          expect(result.kind).to eql("calendar#calendarListEntry")
          expect(result.summary).to eql(calendar_name)
          expect(result.time_zone).to eql("America/New_York")
        end
      end

      context "calendar doesn't exist" do
        let(:calendar_name) { "Class XYZ" }
        let(:time_zone) { "America/New_York" }
        let(:new_calendar) { Google::Apis::CalendarV3::Calendar.new(summary: calendar_name, time_zone: time_zone) }
        let(:insertion_response) { Google::Apis::CalendarV3::Calendar.new(
          summary: calendar_name,
          time_zone: time_zone,
          etag: "\"abc123\"",
          id: "abc123@group.calendar.google.com",
          kind: "calendar#calendar")
        }

        before(:each) do
          allow(service).to receive(:new_calendar).with(calendar_name).and_return(new_calendar)
          allow(client).to receive(:insert_calendar).with(new_calendar).and_return(insertion_response)
          allow(service).to receive(:client).and_return(client)
        end

        it "creates a calendar with the given name" do
          expect(calendar_names.include?(calendar_name)).to be false
          result = service.find_or_create_calendar_by_name(calendar_name)
          expect(result).to be_kind_of(Google::Apis::CalendarV3::Calendar)
          expect(result.id).to be_kind_of(String)
          expect(result.etag).to be_kind_of(String)
          expect(result.kind).to eql("calendar#calendar")
          expect(result.summary).to eql(calendar_name)
          expect(result.time_zone).to eql("America/New_York")
        end
      end

    end

    describe "#new_calendar" do
      let(:calendar_name) { "CSC 111-03" }
      let(:new_calendar) { service.new_calendar(calendar_name) }

      it "initializes a new calendar to be created" do
        expect(new_calendar).to be_kind_of(Google::Apis::CalendarV3::Calendar)
        expect(new_calendar.id).to be nil
        expect(new_calendar.etag).to be nil
        expect(new_calendar.kind).to be nil
        expect(new_calendar.summary).to eql(calendar_name)
        expect(new_calendar.time_zone).to eql("America/New_York")
      end
    end

    #describe "#upcoming_events" do
    #  it "lists upcoming google calendar events on a given calendar" do
    #    service.upcoming_events
    #  end
    #end









     # todo: use an rspec flag and configure rspec to not run that kind of test by default unless you pass a flag
     GO_LIVE = ENV.fetch('GO_LIVE', 'false') == 'true'

     if GO_LIVE
       describe "go-live" do
         before(:all) do ; WebMock.disable! ; end
         after(:all) do ; WebMock.enable! ; end

         before(:each) do
           allow(service).to receive(:sections).and_return(sections)
         end

         it "lets me issue real requests with mock sections" do
           results = service.execute
         end
       end
     end

  end
end
