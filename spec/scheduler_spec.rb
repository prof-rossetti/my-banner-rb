module MyBanner
  RSpec.describe Scheduler do
    include_context "mock sections"

    let(:sections) { mock_sections }
    let(:service) { MyBanner::Scheduler.new }

    describe "#execute" do
      before(:each) do
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

      #it "creates google calendar events" do
      #  expect(service.execute).to eql(true)
      #end
    end

    describe "#calendars" do
      let(:calendars) { service.calendars }

      it "lists and sorts my calendars" do
        expect(calendars.map(&:class).uniq ).to eql( [Google::Apis::CalendarV3::CalendarListEntry] )
        expect(calendars.first.summary).to eql("Contacts")
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
