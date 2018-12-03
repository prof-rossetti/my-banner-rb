
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/try"
require "active_support/core_ext/string/conversions"
#require "active_model" # require "active_model/validations" #> ... uninitialized constant ActiveModel::Validations::EachValidator

#require 'active_model/naming'
#require 'active_model/validator'
#require "active_support/concern"
#require 'active_model/validations'
#require 'active_model/callbacks' # https://stackoverflow.com/questions/37619583/how-to-load-only-activemodel-validations
# is it all worth it?



require "pry"

require "my_banner/version"

require "my_banner/schedule_service"
require "my_banner/page"
require "my_banner/section"
require "my_banner/google_calendar_client"

module MyBanner
end
