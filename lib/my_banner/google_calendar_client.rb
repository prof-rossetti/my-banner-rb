require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  class GoogleCalendarClient < Google::Apis::CalendarV3::CalendarService

    def initialize
      super()
      puts self.class
      self.client_options.application_name = "MyBanner Google Calendar API Client"
      self.api_client.authorization = authorize
      self
    end

    #def client
    #  api_client = Google::Apis::CalendarV3::CalendarService.new
    #  api_client.client_options.application_name = "MyBanner Google Calendar API Client"
    #  api_client.authorization = authorize
    #  api_client
    #end

    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR # permission to read and write, see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    REDIRECT_URL_BASE = "urn:ietf:wg:oauth:2.0:oob" # returns authorization code in browser title bar and promps user to copy the code, see: https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi

    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      client_id = Google::Auth::ClientId.from_file("credentials.json")
      token_store = Google::Auth::Stores::FileTokenStore.new(file: "token.yaml")
      authorizer = Google::Auth::UserAuthorizer.new(client_id, AUTH_SCOPE, token_store)
      binding.pry unless client_id && token_store
      user_id = "default"
      creds = authorizer.get_credentials(user_id)
      if creds.nil?
        auth_url = authorizer.get_authorization_url(base_url: REDIRECT_URL_BASE)
        puts "Please visit the following url: \n\n #{auth_url} \n\n to login to your google account, then paste the resulting code here and press enter... "
        auth_code = gets
        creds = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: auth_code, base_url: REDIRECT_URL_BASE)
      end
      creds
    end

  end
end
