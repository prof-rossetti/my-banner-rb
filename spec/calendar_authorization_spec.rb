module MyBanner
  RSpec.describe CalendarAuthorization do

    it_behaves_like "a GoogleAuthorization" do
      let(:scope) { "https://www.googleapis.com/auth/calendar" }
      let(:credentials_filepath) { "spec/mocks/auth/calendar_credentials.json" }
      let(:token_filepath) { "spec/mocks/auth/calendar_token.yaml" }

      let(:client_id) { "mock-calendar-client-id.apps.googleusercontent.com" }
      let(:client_secret) { "mock-calendar-client-secret" }
      let(:refresh_token) { "mock-calendar-refresh-token" }
    end

  end
end
