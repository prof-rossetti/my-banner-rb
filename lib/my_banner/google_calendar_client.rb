require "google/apis/calendar_v3"

module MyBanner
  class GoogleCalendarClient

    def initialize
      api_client = Google::Apis::CalendarV3::CalendarService.new
      api_client.client_options.application_name = "MyBanner Google Calendar API Client"
      api_client.authorization = GoogleCalendarAPI.new.authorize
      api_client
    end

  end
end
