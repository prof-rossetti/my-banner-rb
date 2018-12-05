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
