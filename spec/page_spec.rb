module MyBanner
  RSpec.describe Page do
    include_context "mock sections"

    let(:page) { described_class.new }

    describe "#parse" do
      it "converts HTML page into useful metadata" do
        expect(page.parse).to eql(page.scheduled_sections)
      end
    end

    describe '#scheduled_sections' do
      let(:sections) { mock_sections }

      before(:each) do
        allow(page).to receive(:scheduled_sections).and_return(sections)
      end

      it "is a machine-readable version of what is visible on the page" do
        expect(page.scheduled_sections.map(&:class).uniq).to eql([MyBanner::Section])
        expect(page.scheduled_sections.count).to eql(3)
      end
    end

  end
end
