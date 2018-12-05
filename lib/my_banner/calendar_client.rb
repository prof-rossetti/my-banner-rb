require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  #todo: CalendarService or Auth or something
  class CalendarClient < Google::Apis::CalendarV3::CalendarService

    AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR # permission to read and write, see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    REDIRECT_URL_BASE = "urn:ietf:wg:oauth:2.0:oob" # returns authorization code in browser title bar and promps user to copy the code, see: https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturiREDIRECT_URL_BASE = "urn:ietf:wg:oauth:2.0:oob" # returns authorization code in browser title bar and promps user to copy the code, see: https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi
    CREDENTIALS_USER_ID = "default"

    def initialize
      super()
      self.client_options.application_name = "MyBanner Google Calendar API Client"
      self.client_options.application_version = VERSION
      self.authorization = authorize
    end

    #private

    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      #raise "MISSING GOOGLE AUTH CREDENTIALS" unless File.exist?(credentials_filepath) && File.exist?(tokenstore_filepath)
      client_id = Google::Auth::ClientId.from_file(credentials_filepath)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: tokenstore_filepath)

      authorizer = Google::Auth::UserAuthorizer.new(client_id, AUTH_SCOPE, token_store)

      credentials = authorizer.get_credentials(CREDENTIALS_USER_ID)

      if credentials.nil?
        # prompt user for results of redirected auth flow
        auth_url = authorizer.get_authorization_url(base_url: REDIRECT_URL_BASE)
        puts "Please visit the following url: \n\n #{auth_url} \n\n to login to your google account, then paste the resulting code here and press enter... "
        auth_code = gets

        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: CREDENTIALS_USER_ID,
          code: auth_code,
          base_url: REDIRECT_URL_BASE
        )
      end

      credentials
    end

    #def authorizer
    #  #raise "MISSING GOOGLE AUTH CREDENTIALS" unless File.exist?(credentials_filepath) && File.exist?(tokenstore_filepath)
    #  client_id = Google::Auth::ClientId.from_file(credentials_filepath)
    #  token_store = Google::Auth::Stores::FileTokenStore.new(file: tokenstore_filepath)
    #  AUTH_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR # permission to read and write, see: https://github.com/googleapis/google-api-ruby-client/blob/6773823e78266830a9a8a651d5fd52e307b63e97/generated/google/apis/calendar_v3.rb#L31-L43
    #  authorizer = Google::Auth::UserAuthorizer.new(client_id, AUTH_SCOPE, token_store)
    #end

    #  REDIRECT_URL_BASE = "urn:ietf:wg:oauth:2.0:oob" # returns authorization code in browser title bar and promps user to copy the code, see: https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi

    #def authorization_url
    #  auth_url = authorizer.get_authorization_url(base_url: REDIRECT_URL_BASE)
    #end

    #def get_and_store_credentials
    #  puts "Please visit the following url: \n\n #{authorization_url} \n\n to login to your google account, then paste the resulting code here and press enter... "
    #  auth_code = gets
    #  credentials = authorizer.get_and_store_credentials_from_code(
    #    user_id: user_id,
    #    code: auth_code,
    #    base_url: REDIRECT_URL_BASE
    #  )
    #end

    def credentials_filepath
      "google_auth/credentials.json"
    end

    def tokenstore_filepath
      "google_auth/token.yaml"
    end

  end
end
