#
# @example
#
#   it_behaves_like "a google api client" do
#     let(:client) { MyBanner::SpreadsheetClient.new }
#
#     let(:client_name) { "MyBanner Spreadsheet Client" }
#     let(:client_id) { "mock-spreadsheet-client-id.apps.googleusercontent.com" }
#     let(:client_secret) { "mock-spreadsheet-client-secret" }
#     let(:auth_scope) { "https://www.googleapis.com/auth/spreadsheets" }
#     let(:refresh_token) { "mock-spreadsheet-refresh-token" }
#   end
#
RSpec.shared_examples "a google api client" do

  it "has client options" do
    opts = client.client_options
    expect(opts).to be_kind_of(Struct)
    expect(opts.application_name).to eql(client_name)
    expect(opts.application_version).to eql(MyBanner::VERSION)
  end

  it "has client credentials and user refresh token" do
    creds = client.authorization
    expect(creds).to be_kind_of(Google::Auth::UserRefreshCredentials)
    expect(creds.client_id).to eql(client_id)
    expect(creds.client_secret).to eql(client_secret)
    expect(creds.scope).to eql([auth_scope])
    expect(creds.refresh_token).to eql(refresh_token)
    expect(creds.expires_at).to be_kind_of(Time)
    expect(creds.expiry).to eql(60)
  end

end
