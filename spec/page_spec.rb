module MyBanner
  RSpec.describe Page do
    include_context "sections"

    let(:page) { described_class.new }

    before(:each) do
      allow(page).to receive(:scheduled_sections).and_return(sections)
    end

    describe "#parse" do
      it "converts HTML page into useful metadata" do
        expect(page.parse).to eql(page.scheduled_sections)
      end
    end

    describe '#scheduled_sections' do
      it "is a machine-readable version of what is visible on the page" do
        expect(page.scheduled_sections.map(&:class).uniq).to eql([MyBanner::Section])
        expect(page.scheduled_sections.count).to eql(3)
      end
    end

  end
end
