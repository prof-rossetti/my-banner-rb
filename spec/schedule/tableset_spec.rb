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
