require "google/apis/calendar_v3"

module MyBanner
  class CalendarAuthorization < GoogleAuthorization

    # permission to read and write ("https://www.googleapis.com/auth/calendar")
    # @see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/calendar_credentials.json"
      options[:token_filepath] ||= "auth/calendar_token.yaml"
      super(options)
    end

  end
end
