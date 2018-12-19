module MyBanner
  RSpec.describe Schedule do

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
      let(:first) { {
        :title=>"Intro to Programming",
        :crn=>"123456",
        :course=>"INFO 101",
        :section=>20,
        :status=>"Open",
        :registration=>"May 01, 2018 - Nov 02, 2018",
        :college=>"School of Business and Technology",
        :department=>"Information Systems",
        :part_of_term=>"C04",
        :credits=>1.5,
        :levels=>["MN or MC Graduate", "Juris Doctor", "Undergraduate"],
        :campus=>"Main Campus",
        :override=>"No",
        :enrollment_counts=>{:maximum=>50, :actual=>45, :remaining=>5},
        :scheduled_meeting_times=>{
          :type=>"Lecture",
          :time=>"11:00 am - 12:20 pm",
          :days=>"TR",
          :where=>"Science Building 111",
          :date_range=>"Oct 29, 2018 - Dec 18, 2018",
          :schedule_type=>"Lecture",
          :instructors=>["Polly Professor"]
        }
      } }
      let(:second) { {
        :title=>"Advanced Programming",
        :crn=>"234567",
        :course=>"INFO 220",
        :section=>40,
        :status=>"Open",
        :registration=>"May 01, 2018 - Nov 02, 2018",
        :college=>"School of Business and Technology",
        :department=>"Information Systems",
        :part_of_term=>"C04",
        :credits=>1.5,
        :levels=>["MN or MC Graduate", "Juris Doctor", "Undergraduate"],
        :campus=>"Main Campus",
        :override=>"No",
        :enrollment_counts=>{:maximum=>50, :actual=>42, :remaining=>8},
        :scheduled_meeting_times=>{
          :type=>"Lecture",
          :time=>"11:00 am - 12:20 pm",
          :days=>"MW",
          :where=>"Science Building 111",
          :date_range=>"Oct 29, 2018 - Dec 18, 2018",
          :schedule_type=>"Lecture",
          :instructors=>["Polly Professor"]
        }
      } }
      let(:third) { {
        :title=>"Advanced Programming",
        :crn=>"345678",
        :course=>"INFO 220",
        :section=>41,
        :status=>"Open",
        :registration=>"May 01, 2018 - Nov 02, 2018",
        :college=>"School of Business and Technology",
        :department=>"Information Systems",
        :part_of_term=>"C04",
        :credits=>1.5,
        :levels=>["MN or MC Graduate", "Juris Doctor", "Undergraduate"],
        :campus=>"Main Campus",
        :override=>"No",
        :enrollment_counts=>{:maximum=>50, :actual=>35, :remaining=>15},
        :scheduled_meeting_times=>{
          :type=>"Lecture",
          :time=>"6:30 pm - 9:20 pm",
          :days=>"M",
          :where=>"Science Building 111",
          :date_range=>"Oct 29, 2018 - Dec 18, 2018",
          :schedule_type=>"Lecture",
          :instructors=>["Polly Professor"]
        }
      } }

      it "wraps metadata in section objects" do
        expect(schedule.sections.map(&:class).uniq).to eql([MyBanner::Section])
        expect(schedule.sections.count).to eql(3)
        expect(schedule.sections.first.metadata).to eql(first)
        expect(schedule.sections.second.metadata).to eql(second)
        expect(schedule.sections.third.metadata).to eql(third)
      end
    end

    describe "#tablesets" do
      it "is a nested collection of three tables per section" do
        expect(schedule.tablesets).to be_kind_of(Array)
        expect(schedule.tablesets.count).to eql(3)

        schedule.tablesets.each do |tableset|
          expect(tableset).to be_kind_of(Schedule::Tableset)
          expect(tableset.info_table.attributes["summary"].value).to eql(info_table_summary)
          expect(tableset.enrollment_table.attributes["summary"].value).to eql(enrollment_table_summary)
          expect(tableset.schedule_table.attributes["summary"].value).to eql(schedule_table_summary)
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
