module MyBanner
  RSpec.describe Schedule::Tableset do
    let(:filepath) { "spec/mocks/pages/faculty-detail-schedule.html" }
    #let(:filepath) { "pages/faculty-detail-schedule.html" }
    let(:doc) { File.open(filepath) { |f| Nokogiri::XML(f) } }
    let(:tables) { doc.css(".pagebodydiv").css("table").first(3) }
    let(:info_table) { tables.first }
    let(:enrollment_table) { tables.second }
    let(:schedule_table) { tables.third }
    let(:tableset) { described_class.new(info_table, enrollment_table, schedule_table) }

    describe "#info" do
      let(:info) { {
        title: "Intro to Programming",
        crn: 123456,
        course: "INFO 101",
        section: 20,
        status: "Open",
        registration: "May 01, 2018 - Nov 02, 2018",
        college: "School of Business and Technology",
        department: "Information Systems",
        part_of_term: "C04",
        credits: 1.5,
        levels: ["MN or MC Graduate", "Juris Doctor", "Undergraduate"],
        campus: "Main Campus",
        override: "No"
      } }

      it "parses info table html" do
        expect(tableset.info).to eql(info)
      end
    end

    describe "#enrollment_counts" do
      let(:enrollment_counts) { {:actual=>45, :maximum=>50, :remaining=>5} }

      it "parses enrollment table html" do
        expect(tableset.enrollment_counts).to eql(enrollment_counts)
      end
    end

    describe "#scheduled_meeting_times" do
      let(:scheduled_meeting_times) { {
        :type=>"Lecture",
        :time=>"11:00 am - 12:20 pm",
        :days=>"TR",
        :where=>"Science Building 111",
        :date_range=>"Oct 29, 2018 - Dec 18, 2018",
        :schedule_type=>"Lecture",
        :instructors=>["Polly Professor"]
      } }

      it "parses schedule table html" do
        expect(tableset.scheduled_meeting_times).to eql(scheduled_meeting_times)
      end
    end

  end
end
