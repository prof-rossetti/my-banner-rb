module MyBanner
  RSpec.describe SpreadsheetService do
    let(:section){ create(:section) }
    let(:service){ described_class.new(section) }

    let(:file_list) {
      Google::Apis::DriveV3::FileList.new(files: [
        Google::Apis::DriveV3::File.new(id: "mock-doc-1", kind: "drive#file", name: "My Spreadshet Document 1", mime_type: "application/vnd.google-apps.spreadsheet"),
        Google::Apis::DriveV3::File.new(id: "mock-doc-2", kind: "drive#file", name: "My Spreadshet Document 2", mime_type: "application/vnd.google-apps.spreadsheet"),
        Google::Apis::DriveV3::File.new(id: "mock-doc-3", kind: "drive#file", name: service.spreadsheet_title, mime_type: "application/vnd.google-apps.spreadsheet")
      ] )
    }
    let(:file) { file_list.files.last }
    let(:new_spreadsheet_attrs) { { properties: {title: file.name } } } # sheets: [roster_sheet]
    let(:new_spreadsheet) { Google::Apis::SheetsV4::Spreadsheet.new(new_spreadsheet_attrs) }
    let(:spreadsheet_attrs) { { properties: {title: file.name }, spreadsheet_id: file.id } } # sheets: [roster_sheet]
    let(:spreadsheet) { Google::Apis::SheetsV4::Spreadsheet.new(spreadsheet_attrs) }

    describe "@spreadsheet_title" do
      let(:title) { "Gradebook - INFO 101 (201810)" }

      it "compiles a gradebook document title from section metadata " do
        expect(service.spreadsheet_title).to eql(title)
      end
    end

    describe "#spreadsheet" do
      context "file exists" do
        before(:each) do
          allow(service).to receive(:spreadsheet_file).and_return(file)
          allow(service.client).to receive(:get_spreadsheet).with(file.id).and_return(spreadsheet)
        end

        it "makes a request for the full spreadsheet object" do
          expect(service.client).to receive(:get_spreadsheet).with(file.id).and_return(spreadsheet)
          service.spreadsheet
        end

        it "returns the existing spreadsheet" do
          expect(service.spreadsheet).to eql(spreadsheet)
          expect(service.spreadsheet).to be_kind_of(Google::Apis::SheetsV4::Spreadsheet)
          expect(service.spreadsheet.spreadsheet_id).to eql(file.id)
        end
      end

      context "file doesn't exist" do
        before(:each) do
          allow(service).to receive(:spreadsheet_file).and_return(nil)
          #allow(service.client).to receive(:create_spreadsheet).with(new_spreadsheet).and_return(spreadsheet) # not operating on the same object so...
          allow(service.client).to receive(:create_spreadsheet).with(kind_of(Google::Apis::SheetsV4::Spreadsheet)).and_return(spreadsheet)
        end

        it "creates a new spreadsheet document" do
          expect(service.spreadsheet_file).to be_nil
          expect(service.client).to receive(:create_spreadsheet).with(kind_of(Google::Apis::SheetsV4::Spreadsheet)).and_return(spreadsheet)
          service.spreadsheet
        end

        it "returns the created spreadsheet" do
          expect(service.spreadsheet).to eql(spreadsheet)
          expect(service.spreadsheet).to be_kind_of(Google::Apis::SheetsV4::Spreadsheet)
          expect(service.spreadsheet.spreadsheet_id).to eql(file.id)
        end
      end
    end

    describe "#spreadsheet_file" do
      before(:each) do
        allow(service).to receive(:file_list).and_return(file_list)
      end

      it "requests all files" do
        expect(service).to receive(:file_list).and_return(file_list)
        service.spreadsheet_file
      end

      it "finds a file with matching title" do
        expect(file_list.files).to respond_to(:find)
        file_names = file_list.files.map{ |f| f.name }
        expect(file_names).to include(service.spreadsheet_title)
      end
    end

    describe "#file_list" do
      let(:request_options) { {q: "mimeType='application/vnd.google-apps.spreadsheet'", order_by: "createdTime desc", page_size: 25} }

      before(:each) do
        allow(service.drive_client).to receive(:list_files).with(request_options).and_return(file_list)
      end

      it "makes a request to the google drive api" do
        expect(service.drive_client).to receive(:list_files).with(request_options).and_return(file_list)
        service.file_list
      end

      it "lists all spreadsheet files" do
        expect(service.file_list).to eql(file_list)
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
