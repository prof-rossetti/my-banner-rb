module MyBanner
  RSpec.describe Scheduler do
    let(:service) { MyBanner::Scheduler.new }

    describe "execute" do
      it "creates google calendar events" do
        expect(service.execute).to eql(true)
      end
    end

  end
end
