module MyBanner
  RSpec.describe Section::Meeting do

    let(:start_at) { DateTime.parse("2018-10-30 11:00 am") }
    let(:end_at) { DateTime.parse("2018-10-30 12:20 pm") }
    let(:meeting) { described_class.new(start_at: start_at, end_at: end_at) }

    describe "#to_s" do
      it "provides a human-readable time string" do
        expect(meeting.to_s).to eql("2018-10-30 11:00 ... 2018-10-30 12:20")
      end
    end

    describe "#to_h" do
      it "provides a hash of attribute values" do
        expect(meeting.to_h).to eql({start_at: start_at, end_at: end_at})
      end
    end

  end
end
