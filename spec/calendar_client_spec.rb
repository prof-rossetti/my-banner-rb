module MyBanner
  RSpec.describe CalendarClient do

    let(:credentials_filepath) { "spec/mocks/calendar_auth/credentials.json" }
    let(:token_filepath) { "spec/mocks/calendar_auth/token.yaml" }
    let(:client) { described_class.new(credentials_filepath: credentials_filepath, token_filepath: token_filepath) }

    it "has client options" do
      opts = client.client_options
      expect(opts).to be_kind_of(Struct)
      expect(opts.application_name).to eql("MyBanner Calendar Client")
      expect(opts.application_version).to eql("0.1.0")
    end

    it "has client credentials and user refresh token" do
      creds = client.authorization
      expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
      expect(creds.client_id).to eql("mock-client-id.apps.googleusercontent.com")
      expect(creds.client_secret).to eql("mock-client-secret")
      expect(creds.scope).to eql(["https://www.googleapis.com/auth/calendar"])
      expect(creds.refresh_token).to eql("mock-refresh-token")
      expect(creds.expires_at).to be_kind_of(Time)
      expect(creds.expiry).to eql(60)
    end

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
            :background_color=>"#9a9cff",
            :color_id=>"17",
            :conference_properties=>{:allowed_conference_solution_types=>["eventHangout"]},
            :default_reminders=>[],
            :etag=>"\"39887154084050222\"",
            :foreground_color=>"#000000",
            :id=>"#contacts@group.v.calendar.google.com",
            :kind=>"calendar#calendarListEntry",
            :summary=> "Holidays in the United States",
            :time_zone=>"America/New_York"
          } )
        ] )
      }

      before(:each) do
        allow(client).to receive(:list_calendar_lists).and_return(calendar_list)
      end

      it "issues an api request" do
        expect(client).to receive(:list_calendar_lists).and_return(calendar_list)
        client.calendars
      end

      it "lists and sorts all my calendars" do
        expect(client.calendars.map(&:class).uniq).to eql([Google::Apis::CalendarV3::CalendarListEntry])
        expect(client.calendars.map(&:summary)).to match_array(["My Calendar XYZ", "Holidays in the United States"])
      end
    end

  end
end
