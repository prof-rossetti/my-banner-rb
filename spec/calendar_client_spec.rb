module MyBanner
  RSpec.describe CalendarClient do

    it_behaves_like "a google api client" do
      include_context "mock calendar authorization"
      let(:client) { described_class.new(mock_calendar_authorization) }
      let(:client_name) { "MyBanner Calendar Client" }
      let(:client_id) { "mock-calendar-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-calendar-client-secret" }
      let(:auth_scope) { "https://www.googleapis.com/auth/calendar" }
      let(:refresh_token) { "mock-calendar-refresh-token" }
    end

    include_context "mock calendar authorization"

    let(:client) { described_class.new(mock_calendar_authorization) }

    it "makes requests on behalf of the user" do
      expect(client).to respond_to(:list_calendar_lists)
      expect(client).to respond_to(:insert_calendar)
      expect(client).to respond_to(:delete_event)
      expect(client).to respond_to(:list_events)
      expect(client).to respond_to(:update_event)
      expect(client).to respond_to(:insert_event)
    end

    describe "#calendars" do
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
            :summary=> "My Calendar XYZ",
            :time_zone=>"America/New_York"
          } ),
          Google::Apis::CalendarV3::CalendarListEntry.new( {
            :access_role=>"reader",
            :background_color=>"#a47ae2",
            :color_id=>"24",
            :conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
            :default_reminders=>[],
            :etag=>"\"1538933735074000\"",
            :foreground_color=>"#000000",
            :id=>"#en.usa@group.v.calendar.google.com",
            :kind=>"calendar#calendarListEntry",
            :selected=>true,
            :summary=> "Holidays in the United States",
            :time_zone=>"America/New_York"
          } )
        ] )
      }

      before(:each) do
        allow(client).to receive(:list_calendar_lists).and_return(calendar_list)
      end

      it "makes a request" do
        expect(client).to receive(:list_calendar_lists).and_return(calendar_list)
        client.calendars
      end

      it "gets google calendars" do
        expect(client.calendars.map(&:class).uniq).to eql([Google::Apis::CalendarV3::CalendarListEntry])
        expect(client.calendars.map(&:summary)).to match_array(["My Calendar XYZ", "Holidays in the United States"])
      end
    end

    describe "#upcoming_events" do
      let(:calendar) { create(:calendar) }

      let(:events) { [ create(:event), create(:all_day_event) ] }
      let(:event_list) { Google::Apis::CalendarV3::Events.new(items: events) }

      let(:upcoming_events) { client.upcoming_events(calendar) }

      #let(:request_options) { {max_results: 100, single_events: true, order_by: "startTime", time_min: Time.now.iso8601, show_deleted: false} }

      before(:each) do
        allow(client).to receive(:list_events).and_return(event_list)
      end

      it "makes a request" do
        expect(client).to receive(:list_events).and_return(event_list)
        #expect(client).to receive(:list_events).with(calendar.id, request_options).and_return(event_list)
        upcoming_events
      end

      it "gets google calendar events" do
        expect(upcoming_events.map(&:class).uniq).to eql( [Google::Apis::CalendarV3::Event] )
        expect(upcoming_events.map(&:summary)).to match_array(["My All-day Event", "My Lunch Event"])
      end

    end
  end
end
