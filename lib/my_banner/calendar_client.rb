require "google/apis/calendar_v3"

module MyBanner
  class CalendarClient < Google::Apis::CalendarV3::CalendarService

    # @param authorization [CalendarAuthorization]
    def initialize(authorization=nil)
      super()
      self.client_options.application_name = "MyBanner Calendar Client"
      self.client_options.application_version = VERSION
      authorization ||= CalendarAuthorization.new
      self.authorization = authorization.stored_credentials || authorization.user_provided_credentials
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
