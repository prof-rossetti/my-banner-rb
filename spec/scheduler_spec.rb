module MyBanner
  RSpec.describe Scheduler do
    include_context "sections"
    include_context "google calendar lists"

    let(:service) { described_class.new }

    let(:client) { instance_double(Google::Apis::CalendarV3::CalendarService, list_calendar_lists: nil)}

    describe "#execute" do
      before(:each) do
        #allow(service).to receive(:client).and_return(client)
        allow(service).to receive(:calendars).and_return([])
        allow(service).to receive(:sections).and_return(sections)
      end

      it "parses the page for scheduled sections" do
        expect(service).to receive(:sections).and_return(sections).at_least(:once)
        service.execute
      end

      it "fetches all google calendars" do
        expect(service).to receive(:calendars)
        service.execute
      end

      it "finds or creates calendars for each section" do
        expect(service).to receive(:find_or_create_calendar_by_name).exactly(3).times
        service.execute
      end

      #it "creates google calendar events" do
      #  expect(service.execute).to eql(true)
      #end
    end

    describe "#calendars" do
      before(:each) do
        allow(service).to receive(:response).and_return(calendar_list)
      end

      it "lists and sorts my calendars" do
        expect(service.calendars.map(&:class).uniq ).to eql( [Google::Apis::CalendarV3::CalendarListEntry] )
        expect(service.calendars.first.summary).to eql("Contacts")
      end
    end

    describe "#response" do
      before(:each) do
        allow(service).to receive(:client).and_return(client)
      end

      it "issues an api request" do
        expect(service.client).to receive(:list_calendar_lists)
        service.response
      end

      context "when successful" do
        before(:each) do
          allow(service).to receive(:response).and_return(calendar_list)
        end

        it "returns a calendar list" do
          expect(service.response.class).to eql(Google::Apis::CalendarV3::CalendarList)
          expect(service.response.items.any?).to be true
          expect(service.response.items.first.class).to eql(Google::Apis::CalendarV3::CalendarListEntry)
        end
      end
    end

    describe "#find_or_create_calendar_by_name" do
      let(:calendar_name) { "Class XYZ" }

      before(:each) do
        allow(service).to receive(:response).and_return(calendar_list)
      end

      it "finds or creates calendars named after each section" do
        expect(service.calendars.map(&:summary).include?(calendar_name)).to be false
        expect(service.find_or_create_calendar_by_name(calendar_name)).to be_kind_of(Google::Apis::CalendarV3::Calendar)
      end
    end

    #describe "#upcoming_events" do
    #  it "lists upcoming google calendar events on a given calendar" do
    #    service.upcoming_events
    #  end
    #end

    #describe "#find_or_create_calendar" do
    #  let(:calendar_name) { "My Section" }
#
    #  it "looks up existing calendar by name, or creates a new one with that name" do
    #    service.find_or_create_calendar(calendar_name)
    #  end
    #end

  end
end
