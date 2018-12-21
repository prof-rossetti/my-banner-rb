module MyBanner
  RSpec.describe SpreadsheetService do
    let(:section){ create(:section) }
    let(:service){ described_class.new(section) }

    describe "#title" do
      let(:title) { "Gradebook - INFO 101 (201810)" }

      it "compiles a gradebook document title from section metadata " do
        expect(service.title).to eql(title)
        expect(service.doc_title).to eql(title)
        expect(service.document_title).to eql(title)
        expect(service.spreadsheet_title).to eql(title)
      end
    end

    describe "#drive_client" do
      it "makes requests to manage spreadsheet files" do
        expect(service.drive_client).to be_kind_of(DriveClient)
      end
    end

  end
end
