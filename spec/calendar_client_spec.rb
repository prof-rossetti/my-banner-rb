
=begin

stub_request(:post, "https://oauth2.googleapis.com/token").with(
    body: {
      "client_id"=>"abc123.apps.googleusercontent.com",
      "client_secret"=>"SKSJW9271HFG510PF",
      "grant_type"=>"refresh_token",
      "refresh_token"=>"26FGDNCO03HJMS"
    },
    headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'Faraday v0.15.3'
    }
  ).to_return(status: 200, body: "", headers: {})

=end

module MyBanner
  RSpec.describe CalendarClient do

    let(:client) { described_class.new }

    before(:each) do

    end

    it "has client options" do
      opts = client.client_options
      expect(opts).to be_kind_of(Struct)
      expect(opts.application_name).to eql("MyBanner Calendar Service")
      expect(opts.application_version).to eql("0.1.0")
    end

  end
end
