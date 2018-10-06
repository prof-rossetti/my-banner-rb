module MyBanner
  RSpec.describe Scheduler do
    let(:service) { MyBanner::Scheduler.new }

    #describe "#execute" do
    #  it "creates google calendar events" do
    #    expect(service.execute).to eql(true)
    #  end
    #end

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

    describe "#calendars" do
      it "lists my calendars" do
        service.calendars
      end
    end

  end
end
