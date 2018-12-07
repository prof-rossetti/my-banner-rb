require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module MyBanner
  class CalendarAuthorizer
    # returns authorization code in browser title bar and promps user to copy the code
    # @see https://developers.google.com/api-client-library/python/auth/installed-app#choosingredirecturi
    BASE_URL = "urn:ietf:wg:oauth:2.0:oob"

    attr_reader :scope, :credentials_filepath, :token_filepath, :user_id

    def initialize(options={})
      @scope = options[:scope] || "https://www.googleapis.com/auth/calendar"
      @credentials_filepath = options[:credentials_filepath] || "calendar_auth/credentials.json"
      @token_filepath = options[:token_filepath] || "calendar_auth/token.yaml"
      @user_id = options[:user_id] || "default"
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
      authorizer.get_credentials(user_id)
    end

    # makes a request to https://oauth2.googleapis.com/token
    def user_provided_credentials
      authorizer.get_and_store_credentials_from_code(user_id: user_id, code: user_provided_code, base_url: BASE_URL)
    end

    def user_provided_code
      puts "Please visit ... \n\n #{authorization_url} \n\n ... login to your google account, get a code, paste it here, and press enter: "
      code = $stdin.gets.chomp
      return code
    end

    def authorization_url
      authorizer.get_authorization_url(base_url: BASE_URL)
    end

  end
end
