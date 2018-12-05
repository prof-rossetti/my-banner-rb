require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  class CalendarAuthorizer # < Google::Auth::UserAuthorizer

    attr_reader :scope

    # @param scope [String] an authorization scope like "https://www.googleapis.com/auth/calendar"
    def initialize(scope)
      @scope = scope
    end

    CREDENTIALS_FILEPATH = "google_auth/credentials.json" # calendar_auth/credentials
    TOKEN_FILEPATH = "google_auth/token.yaml" # calendar_auth/token.yaml

    def authorizer
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_FILEPATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_FILEPATH)
      Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    end

    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def credentials
      stored_credentials || user_provided_credentials
    end

    USER_ID = "default"

    def stored_credentials
      authorizer.get_credentials(USER_ID)
    end

    # returns authorization code in browser title bar and promps user to copy the code
    # @see https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi
    BASE_URL = "urn:ietf:wg:oauth:2.0:oob"

    # prompt user for results of redirected auth flow
    def user_provided_credentials
      authorizer.get_and_store_credentials_from_code(user_id: USER_ID, code: user_provided_code, base_url: BASE_URL)
    end

    def user_provided_code
      auth_url = authorizer.get_authorization_url(base_url: BASE_URL)
      puts "Please visit ... \n\n #{auth_url} \n\n ... login to your google account, get a code, paste it here, and press enter: "
      gets
    end

  end
end
