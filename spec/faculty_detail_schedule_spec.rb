module MyBanner
  RSpec.describe FacultyDetailSchedule do
    let(:filepath) { "spec/mocks/pages/faculty-detail-schedule.html" }
    let(:schedule) { described_class.new(filepath) }

    #let(:sections){ [ create(:section), create(:advanced_section), create(:evening_section) ] }

    #describe "#parse" do
    #  it "converts HTML page into useful metadata" do
    #    expect(schedule.parse).to eql(page.sections)
    #  end
    #end

    describe "#sections" do
      it "is a machine-readable version of what is visible on the page" do
        expect(schedule.sections.map(&:class).uniq).to eql([MyBanner::Section])
        expect(schedule.sections.count).to eql(3)
      end
    end

    describe "#doc" do
      it "represents the entire HTML page" do
        expect(schedule.doc).to be_kind_of(Nokogiri::XML::Document)
      end
    end

  end
end
