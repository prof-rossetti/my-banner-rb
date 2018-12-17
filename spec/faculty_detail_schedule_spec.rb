module MyBanner
  RSpec.describe FacultyDetailSchedule do
    let(:filepath) { "spec/mocks/pages/faculty-detail-schedule.html" }
    let(:schedule) { described_class.new(filepath) }

    #let(:sections){ [ create(:section), create(:advanced_section), create(:evening_section) ] }

    describe "@filepath" do
      it "points to an existing file" do
        expect(schedule.filepath).to eql(filepath)
      end
    end

    describe "#sections" do
      it "wraps metadata in section objects" do
        expect(schedule.sections.map(&:class).uniq).to eql([MyBanner::Section])
        expect(schedule.sections.count).to eql(3)
      end
    end

    describe "#sections_metadata" do
      it "extracts metadata from HTML" do
        expect(schedule.sections_metadata).to be_kind_of(Array)
        expect(schedule.sections_metadata.first).to be_kind_of(Hash)
        expect(schedule.sections_metadata.count).to eql(3)
      end
    end

    #describe "#tablesets" do
    #end

    describe "#tables" do
      let(:info_table_summary) { "This layout table is used to present instructional assignments for the selected Term.." }
      let(:enrollment_table_summary) { "This table displays enrollment and waitlist counts." }
      let(:schedule_table_summary) { "This table lists the scheduled meeting times and assigned instructors for this class.." }

      it "represents all relevant tables" do
        expect(schedule.tables).to be_kind_of(Nokogiri::XML::NodeSet)
        expect(schedule.tables.first).to be_kind_of(Nokogiri::XML::Element)
      end

      it "three kinds" do
        expect(schedule.tables.count).to eql(9)
        expect(schedule.tables.select { |t| t.attributes["summary"].value == info_table_summary}.count ).to eql(3)
        expect(schedule.tables.select { |t| t.attributes["summary"].value == enrollment_table_summary}.count ).to eql(3)
        expect(schedule.tables.select { |t| t.attributes["summary"].value == schedule_table_summary}.count ).to eql(3)
      end
    end

    describe "#doc" do
      it "represents the entire HTML page" do
        expect(schedule.doc).to be_kind_of(Nokogiri::XML::Document)
      end
    end

  end
end
