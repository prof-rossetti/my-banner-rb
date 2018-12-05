require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  class CalendarAuthorizer
    # returns authorization code in browser title bar and promps user to copy the code
    # @see https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi
    BASE_URL = "urn:ietf:wg:oauth:2.0:oob"
    USER_ID = "default"

    attr_reader :scope, :credentials_filepath, :token_filepath

    def initialize(scope, credentials_filepath=nil, token_filepath=nil)
      @scope = scope || "https://www.googleapis.com/auth/calendar"
      @credentials_filepath = credentials_filepath || "google_auth/credentials.json"
      @token_filepath = token_filepath || "google_auth/token.yaml"
    end

    def authorizer
      client_id = Google::Auth::ClientId.from_file(credentials_filepath)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: token_filepath)
      Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    end

    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def credentials
      stored_credentials || user_provided_credentials
    end

    def stored_credentials
      authorizer.get_credentials(USER_ID)
    end

    def user_provided_credentials
      authorizer.get_and_store_credentials_from_code(user_id: USER_ID, code: user_provided_code, base_url: BASE_URL)
    end

    def user_provided_code
      puts "Please visit ... \n\n #{authorization_url} \n\n ... login to your google account, get a code, paste it here, and press enter: "
      gets
    end

    def authorization_url
      authorizer.get_authorization_url(base_url: BASE_URL)
    end

  end
end
