module MyBanner
  RSpec.describe SpreadsheetAuthorization do

    it_behaves_like "a GoogleAuthorization" do
      let(:scope) { "https://www.googleapis.com/auth/spreadsheets" }
      let(:credentials_filepath) { "spec/mocks/auth/spreadsheet_credentials.json" }
      let(:token_filepath) { "spec/mocks/auth/spreadsheet_token.yaml" }

      let(:client_id) { "mock-spreadsheet-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-spreadsheet-client-secret" }
      let(:refresh_token) { "mock-spreadsheet-refresh-token" }
    end

    #describe "#stored_credentials" do
    #  it "returns google credentials" do
#
    #    #auth = MyBanner::SpreadsheetAuthorization.new(credentials_filepath: "auth/spreadsheet_credentials.json", token_filepath: "auth/spreadsheet_token.yaml")
    #    #creds = auth.stored_credentials
    #    #expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
#
#
    #    credentials_filepath = "spec/mocks/auth/spreadsheet_credentials.json"
    #    token_filepath = "spec/mocks/auth/spreadsheet_token.yaml"
    #    scope = "https://www.googleapis.com/auth/spreadsheets"
    #    authorization = MyBanner::SpreadsheetAuthorization.new(credentials_filepath: credentials_filepath, token_filepath: token_filepath)
#
    #    client_id = "mock-spreadsheet-client-id.apps.googleusercontent.com"
    #    client_secret = "mock-spreadsheet-client-secret"
    #    refresh_token = "mock-spreadsheet-refresh-token"
#
    #    expect(File.exist?(credentials_filepath)).to eql(true)
    #    expect(File.exist?(token_filepath)).to eql(true)
#
    #    creds = authorization.stored_credentials
    #    expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
    #    expect(creds.client_id).to eql(client_id)
    #    expect(creds.client_secret).to eql(client_secret)
    #    expect(creds.refresh_token).to eql(refresh_token)
    #    expect(creds.expires_at).to be_kind_of(Time)
    #    expect(creds.expiry).to eql(60)
    #    expect(creds.scope).to eql([scope])
    #  end
    #end







  end
end
