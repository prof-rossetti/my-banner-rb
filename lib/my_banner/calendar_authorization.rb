require "google/apis/calendar_v3"

module MyBanner
  class CalendarAuthorization < GoogleAuthorization

    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR #> "https://www.googleapis.com/auth/calendar"

    def initialize(options={})
      options[:scope] ||= AUTH_SCOPE
      options[:credentials_filepath] ||= "auth/calendar_credentials.json"
      options[:token_filepath] ||= "auth/calendar_token.yaml"
      super(options)
    end

  end
end
