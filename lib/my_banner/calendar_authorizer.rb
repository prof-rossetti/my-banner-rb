require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  class CalendarAuthorizer < Google::Auth::UserAuthorizer

    def initialize(auth_scope, credentials_filepath=nil, token_filepath=nil)
      auth_scope ||= "https://www.googleapis.com/auth/calendar"
      credentials_filepath ||= "google_auth/credentials.json"
      token_filepath ||= "google_auth/token.yaml"

      client_id = Google::Auth::ClientId.from_file(credentials_filepath)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: token_filepath)
      super(client_id, auth_scope, token_store)
    end

    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def credentials
      stored_credentials || user_provided_credentials
    end

    USER_ID = "default"

    def stored_credentials
      get_credentials(USER_ID)
    end

    # returns authorization code in browser title bar and promps user to copy the code
    # @see https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi
    BASE_URL = "urn:ietf:wg:oauth:2.0:oob"

    # prompt user for results of redirected auth flow
    def user_provided_credentials
      get_and_store_credentials_from_code(user_id: USER_ID, code: user_provided_code, base_url: BASE_URL)
    end

    def user_provided_code
      puts "Please visit ... \n\n #{authorization_url} \n\n ... login to your google account, get a code, paste it here, and press enter: "
      gets
    end

    def authorization_url
      get_authorization_url(base_url: BASE_URL)
    end

  end
end
