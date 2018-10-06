module MyBanner
  RSpec.describe Page do
    include_context "section metadata"

    let(:page) { described_class.new }

    describe "#parse" do
      it "converts HTML page into useful metadata" do
        expect(page.parse).to eql(page.scheduled_sections)
      end
    end

    describe '#scheduled_sections' do
      it "is a machine-readable version of what is visible on the page" do
        expect(page.scheduled_sections).to eql([section_metadata])
      end
    end

  end
end
