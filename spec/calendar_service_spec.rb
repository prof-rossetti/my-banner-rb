module MyBanner
  RSpec.describe CalendarService do
    include_context "mock calendar client"

    let(:section) { create(:section) }
    let(:service) { described_class.new(section) }

    before(:each) do
      allow(service).to receive(:client).and_return(mock_calendar_client)
    end

    let(:calendar_name) { section.abbreviation }
    let(:calendar_list_item) { Google::Apis::CalendarV3::CalendarListEntry.new(
      :access_role=>"reader",
      :background_color=>"#9a9cff",
      :color_id=>"17",
      :conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
      :default_reminders=>[],
      :etag=>"\"39887154084050111\"",
      :foreground_color=>"#000000",
      :id=>"#contacts@group.v.calendar.google.com",
      :kind=>"calendar#calendarListEntry",
      :summary=> calendar_name,
      :time_zone=>"America/New_York"
    ) }
    let(:calendar_list) { Google::Apis::CalendarV3::CalendarList.new(items: [calendar_list_item]) }

    let(:events) { [ create(:event), create(:all_day_event) ] }
    let(:event_list) { Google::Apis::CalendarV3::Events.new(items: events) }

    describe "#execute" do
      describe "for each meeting" do
        let(:events) { [ create(:event) ] }
        let(:meeting) { service.meetings.first }

        before(:each) do
          allow(service).to receive(:meetings).and_return([meeting]) # test for single meeting only
        end

        context "event exists" do
          let(:event){ events.first }

          before(:each) do
            allow(service).to receive(:find_event).with(meeting.to_h).and_return(event)
          end

          it "overwrites the event with expected attributes" do
            expect(service).to receive(:update_event).with(event, meeting.to_h)
            service.execute
          end
        end

        context "event doesn't exist" do
          before(:each) do
            allow(service).to receive(:find_event).with(meeting.to_h).and_return(nil)
          end

          it "creates a new event" do
            expect(service).to receive(:create_event).with(meeting.to_h)
            service.execute
          end
        end
      end
    end

    describe "#events" do
      let(:calendar) { create(:calendar, summary: calendar_name) }

      before(:each) do
        allow(service).to receive(:calendar).and_return(calendar)
      end

      it "fetches upcoming events" do
        expect(service.client).to receive(:upcoming_events).with(calendar)
        service.events
      end
    end

    describe "#calendar" do
      let(:calendar_names) { service.client.calendars.map(&:summary) }

      let(:cal) { service.calendar }

      context "calendar exists" do
        before(:each) do
          allow(service.client).to receive(:calendars).and_return([calendar_list_item])
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
        let(:calendar) { create(:calendar, summary: calendar_name, time_zone: "America/New_York") }
        let(:insertion_response) { calendar }

        before(:each) do
          allow(service.client).to receive(:calendars).and_return([])
          allow(service).to receive(:new_calendar).and_return(new_calendar)
          allow(service.client).to receive(:insert_calendar).with(new_calendar).and_return(insertion_response)
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
