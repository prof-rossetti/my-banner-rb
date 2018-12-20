require "active_support/core_ext/array"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/try"
require "active_support/core_ext/string/conversions"
#require "googleauth"
#require "googleauth/stores/file_token_store"
#require "google/apis/calendar_v3"
#require "google/apis/drive_v3"
#require "google/apis/sheets_v4"
#require "nokogiri"
require "pry"

require "my_banner/version"

require "my_banner/google_authorization"

require "my_banner/calendar_authorization"
require "my_banner/calendar_client"
require "my_banner/calendar_service"
require "my_banner/drive_authorization"
require "my_banner/drive_client"
require "my_banner/spreadsheet_authorization"
require "my_banner/spreadsheet_client"
require "my_banner/spreadsheet_service"

require "my_banner/schedule"
require "my_banner/schedule/tableset"
require "my_banner/section" # consider "my_banner/schedule/tableset/section"
require "my_banner/section/meeting" # consider "my_banner/schedule/tableset/section/meeting" but that's starting to get out of hand, no?

module MyBanner
end
