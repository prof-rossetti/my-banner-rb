require "active_support/core_ext/array"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/try"
require "active_support/core_ext/string/conversions"
require "nokogiri"
require "pry"

require "my_banner/version"

require "my_banner/calendar_authorization"
require "my_banner/calendar_client"
require "my_banner/calendar_service"

require "my_banner/schedule"
require "my_banner/schedule/tableset"
require "my_banner/section"
require "my_banner/section/meeting"

module MyBanner
end
