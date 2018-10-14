module MyBanner
  RSpec.describe ScheduleService do
    include_context "sections"
    include_context "google calendar lists"
    include_context "google calendar events"

    let(:client) { instance_double(Google::Apis::CalendarV3::CalendarService, list_calendar_lists: nil, insert_calendar: nil, list_events: nil) }
    let(:service) { described_class.new(section) }

    before(:each) do
      allow(service).to receive(:client).and_return(client) # mock the client, because it makes an auth request
    end

    let(:calendar) {
      Google::Apis::CalendarV3::Calendar.new(
        summary: section.calendar_name,
        time_zone: "America/New_York",
        etag: "\"...\"",
        id: "myclass1@group.calendar.google.com",
        kind: "calendar#calendar"
      )
    }

    # describe "#execute" do
    # end

    describe "#events" do
      before(:each) do
        allow(service).to receive(:calendar).and_return(calendar)
        allow(client).to receive(:list_events).and_return(events_response)
      end

      it "returns a list of google calendar events" do
        expect(service.events.map(&:class).uniq).to eql( [Google::Apis::CalendarV3::Event] )
        expect(service.events.map(&:summary)).to match_array(["My Day-long Event", "My Lunch Event"])
      end
    end

    describe "#calendar" do
      let(:calendar_names) { service.calendars.map(&:summary) }

      before(:each) do
        allow(service).to receive(:list_calendars).and_return(calendar_list)
      end

      context "calendar exists" do
        let(:calendar_name) { "Contacts" }

        it "finds a calendar with the given name" do
          expect(service.calendar.include?(calendar_name)).to be true
          expect(service.calendar).to be_kind_of(Google::Apis::CalendarV3::CalendarListEntry)
          expect(service.calendar.id).to be_kind_of(String)
          expect(service.calendar.etag).to be_kind_of(String)
          expect(service.calendar.kind).to eql("calendar#calendarListEntry")
          expect(service.calendar.summary).to eql(calendar_name)
          expect(service.calendar.time_zone).to eql("America/New_York")
        end
      end

      context "calendar doesn't exist" do
        let(:calendar_name) { "Class XYZ" }
        let(:time_zone) { "America/New_York" }
        let(:new_calendar) { Google::Apis::CalendarV3::Calendar.new(summary: calendar_name, time_zone: time_zone) }
        let(:insertion_response) { calendar }

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

    describe "#calendars" do
      before(:each) do
        allow(service).to receive(:list_calendars).and_return(calendar_list)
      end

      it "lists and sorts all my calendars" do
        expect(service.calendars.map(&:class).uniq ).to eql( [Google::Apis::CalendarV3::CalendarListEntry] )
        expect(service.calendars.first.summary).to eql("Contacts")
      end
    end

    describe "#list_events" do
      before(:each) do
        allow(service).to receive(:calendar).and_return(calendar)
        allow(client).to receive(:list_events).and_return(events_response)
      end

      it "issues a request" do
        expect(client).to receive(:list_events).and_return(events_response)
        service.send(:list_events)
      end

      it "returns a response" do
        expect(service.send(:list_events)).to eql(events_response)
        expect(service.send(:list_events)).to be_kind_of(Google::Apis::CalendarV3::Events)
      end
    end

        describe "#list_calendars" do
      before(:each) do
        allow(service).to receive(:client).and_return(client)
      end

      it "issues an api request" do
        expect(service.client).to receive(:list_calendar_lists)
        service.list_calendars
      end

      context "when successful" do
        before(:each) do
          allow(service).to receive(:list_calendars).and_return(calendar_list)
        end

        it "returns a calendar list" do
          expect(service.list_calendars.class).to eql(Google::Apis::CalendarV3::CalendarList)
          expect(service.list_calendars.items.any?).to be true
          expect(service.list_calendars.items.first.class).to eql(Google::Apis::CalendarV3::CalendarListEntry)
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

  end
end
