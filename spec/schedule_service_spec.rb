module MyBanner
  RSpec.describe ScheduleService do
    include_context "google calendar events"

    let(:section) { create(:section) }
    let(:calendar_list) {
      Google::Apis::CalendarV3::CalendarList.new(items: [
        Google::Apis::CalendarV3::CalendarListEntry.new( {
          :access_role=>"reader",
          :background_color=>"#9a9cff",
          :color_id=>"17",
          :conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
          :default_reminders=>[],
          :etag=>"\"39887154084050111\"",
          :foreground_color=>"#000000",
          :id=>"#contacts@group.v.calendar.google.com",
          :kind=>"calendar#calendarListEntry",
          :summary=> section.calendar_name,
          :time_zone=>"America/New_York"
        } )
      ] )
    }
    let(:client) { instance_double(Google::Apis::CalendarV3::CalendarService, list_calendar_lists: nil, insert_calendar: nil, list_events: nil) }
    let(:service) { described_class.new(section) }

    before(:each) do
      allow(service).to receive(:client).and_return(client)
    end

    let(:calendar_name) { service.calendar_name }
    let(:calendar) { create(:calendar, summary: calendar_name) }

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
      let(:cal) { service.calendar }

      context "calendar exists" do
        before(:each) do
          allow(service).to receive(:list_calendars).and_return(calendar_list)
        end

        it "finds a calendar with the given name" do
          expect(calendar_names).to include(calendar_name)
          expect(cal).to be_kind_of(Google::Apis::CalendarV3::CalendarListEntry)
          expect(cal.kind).to eql("calendar#calendarListEntry")
          expect(cal.id).to be_kind_of(String)
          expect(cal.etag).to be_kind_of(String)
          expect(cal.summary).to eql(calendar_name)
          expect(cal.time_zone).to eql("America/New_York")
        end
      end

      context "calendar doesn't exist" do
        let(:new_calendar) { Google::Apis::CalendarV3::Calendar.new(summary: calendar_name, time_zone: "America/New_York") }
        let(:insertion_response) { calendar }

        before(:each) do
          allow(service).to receive(:calendars).and_return([])
          allow(service).to receive(:new_calendar).and_return(new_calendar)
          allow(client).to receive(:insert_calendar).with(new_calendar).and_return(insertion_response)
        end

        it "creates a calendar with the given name" do
          expect(calendar_names).to_not include(calendar_name)
          expect(cal).to be_kind_of(Google::Apis::CalendarV3::Calendar)
          expect(cal.kind).to eql("calendar#calendar")
          expect(cal.id).to be_kind_of(String)
          expect(cal.etag).to be_kind_of(String)
          expect(cal.summary).to eql(calendar_name)
          expect(cal.time_zone).to eql("America/New_York")
        end
      end
    end

    describe "#calendars" do
      before(:each) do
        allow(service).to receive(:list_calendars).and_return(calendar_list)
      end

      it "lists and sorts all my calendars" do
        expect(service.calendars.map(&:class).uniq ).to eql( [Google::Apis::CalendarV3::CalendarListEntry] )
        expect(service.calendars.first.summary).to eql(calendar_name)
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
      let(:results) { service.send(:list_calendars) }

      it "issues an api request" do
        expect(service.client).to receive(:list_calendar_lists)
        results
      end

      context "when successful" do
        before(:each) do
          allow(service).to receive(:list_calendars).and_return(calendar_list)
        end

        it "returns a calendar list" do
          expect(results.class).to eql(Google::Apis::CalendarV3::CalendarList)
          expect(results.items.any?).to be true
          expect(results.items.first.class).to eql(Google::Apis::CalendarV3::CalendarListEntry)
        end
      end
    end

    describe "#new_calendar" do
      let(:new_calendar) { service.send(:new_calendar) }

      it "initializes a new calendar" do
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
