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

    describe "#docs" do
      let(:request_options) { {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25} }

      let(:file_list) {
        Google::Apis::DriveV3::FileList.new(files: [
          Google::Apis::DriveV3::File.new(properties: {id: "doc-1", kind: "drive#file", name: "My Spreadshet Document 1", mime_type: "application/vnd.google-apps.spreadsheet"}),
          Google::Apis::DriveV3::File.new(properties: {id: "doc-2", kind: "drive#file", name: "My Spreadshet Document 2", mime_type: "application/vnd.google-apps.spreadsheet"}),
          Google::Apis::DriveV3::File.new(properties: {id: "doc-3", kind: "drive#file", name: "My Spreadshet Document 3", mime_type: "application/vnd.google-apps.spreadsheet"})
        ] )
      }

      before(:each) do
        allow(service.drive_client).to receive(:list_files).with(request_options).and_return(file_list)
      end

      it "makes a request to the google drive api" do
        expect(service.drive_client).to receive(:list_files).with(request_options).and_return(file_list)
        service.docs
      end

      it "lists all spreadsheet files" do
        expect(service.docs).to eql(file_list)
      end
    end

    describe "#client" do
      it "makes requests to the google sheets api" do
        expect(service.drive_client).to be_kind_of(SpreadsheetClient)
      end
    end

    describe "#drive_client" do
      it "makes requests to the google drive api" do
        expect(service.drive_client).to be_kind_of(DriveClient)
      end
    end

  end
end
