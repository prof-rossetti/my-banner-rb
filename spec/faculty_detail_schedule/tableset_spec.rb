module MyBanner
  RSpec.describe FacultyDetailSchedule::Tableset do
    let(:filepath) { "spec/mocks/pages/faculty-detail-schedule.html" }
    let(:doc) { File.open(filepath) { |f| Nokogiri::XML(f) } }
    let(:tables) { doc.css(".pagebodydiv").css("table") }
    let(:info_table) { tables.first[0] }
    let(:enrollment_table) { tables.first[1] }
    let(:schedule_table) { tables.first[2] }
    let(:tableset) { described_class.new(info_table, enrollment_table, schedule_table) }

    describe "#scheduled_meeting_times" do
      let(:scheduled_meeting_times) { {} }

      it "parses schedule table html" do
        expect(tableset.scheduled_meeting_times).to eql(scheduled_meeting_times)
      end
    end

  end
end
