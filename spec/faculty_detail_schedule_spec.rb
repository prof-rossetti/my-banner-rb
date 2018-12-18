module MyBanner
  RSpec.describe FacultyDetailSchedule do
    let(:filepath) { "spec/mocks/pages/faculty-detail-schedule.html" }
    let(:schedule) { described_class.new(filepath) }

    let(:info_table_summary) { "This layout table is used to present instructional assignments for the selected Term.." }
    let(:enrollment_table_summary) { "This table displays enrollment and waitlist counts." }
    let(:schedule_table_summary) { "This table lists the scheduled meeting times and assigned instructors for this class.." }

    describe "::TABLE_SUMMARIES" do
      it "describes a set of expected table summaries for each section" do
        expect(described_class::TABLE_SUMMARIES).to eql( {
          info: info_table_summary,
          enrollment: enrollment_table_summary,
          schedule: schedule_table_summary
        } )
      end
    end

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
      let(:sections){ [ create(:section), create(:advanced_section), create(:evening_section) ] } # TODO: revise approach
      let(:metadata) { sections.first.metadata }

      let(:enrollment_counts) { { actual: 45, maximum: 50, remaining: 5 } }
      let(:scheduled_meeting_times) { {
        type: "Lecture",
        time: "11:00 am - 12:20 pm",
        days: "TR",
        where: "Science Building 111",
        date_range: "Oct 29, 2018 - Dec 18, 2018",
        schedule_type: "Lecture",
        instructors: ["Polly Professor"]
      } }

      it "extracts section metadata from each tableset" do
        expect(schedule.sections_metadata).to be_kind_of(Array)
        expect(schedule.sections_metadata.first).to be_kind_of(Hash)
        expect(schedule.sections_metadata.count).to eql(3)
        #expect(schedule.sections_metadata.first).to eql(metadata)
        expect(schedule.sections_metadata.first[:enrollment_counts]).to eql(enrollment_counts)
        expect(schedule.sections_metadata.first[:scheduled_meeting_times]).to eql(scheduled_meeting_times)
      end
    end

    describe "#tablesets" do
      it "is a nested collection of three tables per section" do
        expect(schedule.tablesets).to be_kind_of(Array)
        expect(schedule.tablesets.count).to eql(3)

        schedule.tablesets.each do |tableset|
          expect(tableset).to be_kind_of(Array)
          expect(tableset.count).to eql(3)
          expect(tableset.map(&:class).uniq).to match_array([Nokogiri::XML::Element])
          expect(tableset.map{ |t| t.attributes["summary"].value }).to match_array([info_table_summary, enrollment_table_summary, schedule_table_summary])
        end
      end
    end

    describe "#tables" do
      it "is a flat collection of three tables per section" do
        expect(schedule.tables).to be_kind_of(Nokogiri::XML::NodeSet)
        expect(schedule.tables.count).to eql(9)

        expect(schedule.tables.map(&:class).uniq).to match_array([Nokogiri::XML::Element])
        summaries = schedule.tables.map { |t| t.attributes["summary"].value }
        expect(summaries).to match_array([
          info_table_summary, enrollment_table_summary, schedule_table_summary,
          info_table_summary, enrollment_table_summary, schedule_table_summary,
          info_table_summary, enrollment_table_summary, schedule_table_summary,
        ])
      end
    end

    describe "#doc" do
      it "represents the entire HTML page" do
        expect(schedule.doc).to be_kind_of(Nokogiri::XML::Document)
      end
    end

  end
end
