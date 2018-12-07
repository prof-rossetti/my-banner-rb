require "google/apis/calendar_v3"

module MyBanner
  class CalendarClient < Google::Apis::CalendarV3::CalendarService

    # permission to read and write
    # @see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR #> "https://www.googleapis.com/auth/calendar"

    def initialize(options={})
      credentials_filepath = options[:credentials_filepath] || "calendar_auth/credentials.json"
      token_filepath = options[:token_filepath] || "calendar_auth/token.yaml"
      authorizer = CalendarAuthorizer.new(credentials_filepath: credentials_filepath, scope: AUTH_SCOPE, token_filepath: token_filepath)

      super()
      self.client_options.application_name = "MyBanner Calendar Client"
      self.client_options.application_version = VERSION
      self.authorization = authorizer.credentials
    end

    def calendars
      @calendars ||= list_calendar_lists.items.sort_by { |cal| cal.summary }
    end

    # @param calendar [Google::Apis::CalendarV3::Calendar]
    def upcoming_events(calendar)
      request_options = {max_results: 100, single_events: true, order_by: "startTime", time_min: Time.now.iso8601, show_deleted: false}
      list_events(calendar.id, request_options).items
    end

  end
end
