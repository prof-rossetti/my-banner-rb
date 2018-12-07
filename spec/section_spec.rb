module MyBanner
  RSpec.describe Section do
    let(:section) { create(:section) }

    describe "#abbreviation" do
      it "combines course abbreviation with section" do
        expect(section.abbreviation).to eql("INFO 101-20")
      end
    end

    describe "#term_start" do
      it "is the date before which there are no classes scheduled" do
        expect(section.term_start).to be_kind_of(Date)
        expect(section.term_start.to_s).to eql("2018-10-29")
      end
    end

    describe "#term_end" do
      it "is the date after which there are no classes scheduled" do
        expect(section.term_end).to be_kind_of(Date)
        expect(section.term_end.to_s).to eql("2018-12-18")
      end
    end

    describe "#weekdays" do
      it "lists the days of the week on which the class meets" do
        expect(section.weekdays).to match_array(["T", "R"])
      end
    end

    describe "#start_time" do
      it "is the time class starts on any given meeting day" do
        expect(section.start_time).to eql("11:00 am")
      end
    end

    describe "#end_time" do
      it "is the time class ends on any given meeting day" do
        expect(section.end_time).to eql("12:20 pm")
      end
    end

    describe "#location" do
      it "identifies the building and room where the class is held" do
        expect(section.location).to eql("Science Building 111")
      end
    end

    describe "#instructor" do
      it "refers to the primary instructor" do
        expect(section.instructor).to eql("Polly Professor")
      end
    end

    describe "#meetings" do
      it "enumerates meeting datetimes between term start and end" do
        expect(section.meetings.count).to eql(15)
        expect(section.meetings.map(&:class).uniq).to eql([ MyBanner::Section::Meeting ])
        expect(section.meetings.map{ |m| m.start_at.class }.uniq).to eql([ DateTime ])
        expect(section.meetings.map{ |m| m.end_at.class }.uniq).to eql([ DateTime ])
        expect(section.meetings.map{ |m| m.start_at.strftime("%H:%M %P") }.uniq).to eql([ "11:00 am" ])
        expect(section.meetings.map{ |m| m.end_at.strftime("%H:%M %P") }.uniq).to eql([ "12:20 pm" ])
      end
    end

    describe "#meeting_dates" do
      it "enumerates meeting dates between term start and end" do
        expect(section.meeting_dates.count).to eql(15)
        expect(section.meeting_dates.map(&:class).uniq).to eql([Date])
      end
    end

  end
end
