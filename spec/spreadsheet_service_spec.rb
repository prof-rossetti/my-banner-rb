module MyBanner
  RSpec.describe SpreadsheetService do
    let(:section){ create(:section) }
    let(:service){ described_class.new(section) }

    let(:file_list) {
      Google::Apis::DriveV3::FileList.new(files: [
        Google::Apis::DriveV3::File.new(properties: {id: "doc-1", kind: "drive#file", name: "My Spreadshet Document 1", mime_type: "application/vnd.google-apps.spreadsheet"}),
        Google::Apis::DriveV3::File.new(properties: {id: "doc-2", kind: "drive#file", name: "My Spreadshet Document 2", mime_type: "application/vnd.google-apps.spreadsheet"}),
        Google::Apis::DriveV3::File.new(properties: {id: "doc-3", kind: "drive#file", name: "My Spreadshet Document 3", mime_type: "application/vnd.google-apps.spreadsheet"})
      ] )
    }

    describe "#title" do
      let(:title) { "Gradebook - INFO 101 (201810)" }

      it "compiles a gradebook document title from section metadata " do
        expect(service.title).to eql(title)
        expect(service.doc_title).to eql(title)
        expect(service.document_title).to eql(title)
        expect(service.spreadsheet_title).to eql(title)
      end
    end

    describe "#spreadsheet" do
      #it "checks for an existing file with matching title" do
      #  expect(service).to receive(:docs).and_return(file_list)
      #  service.spreadsheet
      #end

      context "file exists" do
        let(:file) { file_list.files.last }
        let(:file_name) { file.properties[:name] }
        let(:spreadsheet_attrs) { { properties: {title: file_name } } } # sheets: [roster_sheet]
        let(:spreadsheet) { Google::Apis::SheetsV4::Spreadsheet.new(spreadsheet_attrs) }

        before(:each) do
          #allow(service).to receive(:spreadsheet_title).and_return(file_name)
          #allow(service).to receive(:docs).and_return(file_list)
          allow(service).to receive(:spreadsheet_file).and_return(file)
          allow(service.client).to receive(:get_spreadsheet).and_return(spreadsheet)
        end

        it "finds the matching file" do
          allow(service).to receive(:spreadsheet_title).and_return(file_name)
          file_names = file_list.files.map{ |f| f.properties[:name] }
          expect(file_names).to include(service.spreadsheet_title)
        end

        it "makes a request for the full spreadsheet object" do
          expect(service.client).to receive(:get_spreadsheet).with(file.id)
          service.spreadsheet
        end

        it "returns the spreadsheet" do
          expect(service.spreadsheet).to eql(spreadsheet)
        end
      end

      #context "document doesn't exist" do
      #  it "creates a new spreadsheet document" do
#
      #  end
#
      #  it "returns the spreadsheet" do
#
      #  end
      #end
    end

    describe "#docs" do
      let(:request_options) { {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25} }

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
        expect(service.client).to be_kind_of(SpreadsheetClient)
      end
    end

    describe "#drive_client" do
      it "makes requests to the google drive api" do
        expect(service.drive_client).to be_kind_of(DriveClient)
      end
    end

  end
end
