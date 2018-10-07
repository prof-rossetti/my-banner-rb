module MyBanner
  RSpec.describe Section do
    include_context "sections"

    let(:section) { described_class.new(section_metadata) }

    describe '#abbreviation' do
      it "combines course abbreviation with section" do
        expect(section.abbreviation).to eql("INFO 101-20")
      end
    end

    describe '#start_date' do
      it "is the date before which there are no classes scheduled" do
        expect(section.start_date).to eql("Oct 29, 2018")
      end
    end

    describe '#end_date' do
      it "is the date after which there are no classes scheduled" do
        expect(section.end_date).to eql("Dec 18, 2018")
      end
    end

    describe '#weekdays' do
      it "lists the days of the week on which the class meets" do
        expect(section.weekdays).to match_array(["T", "R"])
      end
    end

    describe '#start_time' do
      it "is the time class starts on any given meeting day" do
        expect(section.start_time).to eql("11:00 am")
      end
    end

    describe '#end_time' do
      it "is the time class ends on any given meeting day" do
        expect(section.end_time).to eql("12:20 pm")
      end
    end

    describe '#location' do
      it "identifies the building and room where the class is held" do
        expect(section.location).to eql("Science Building 111")
      end
    end

  end
end

