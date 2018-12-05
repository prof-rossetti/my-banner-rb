

require "google/apis/calendar_v3"

module MyBanner
  class CalendarClient < Google::Apis::CalendarV3::CalendarService # class CalendarService < Google::Apis::CalendarV3::CalendarService

    # permission to read and write
    # @see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR #> "https://www.googleapis.com/auth/calendar"

    def initialize
      super()
      self.client_options.application_name = "MyBanner Calendar Service"
      self.client_options.application_version = VERSION
      self.authorization = CalendarAuthorizer.new(AUTH_SCOPE).credentials
    end

  end
end
