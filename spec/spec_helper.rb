require "bundler/setup"
require "my_banner"

require "factory_bot"
require "webmock/rspec"

Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end # h/t: https://stackoverflow.com/a/21851294/670433

Dir[File.expand_path('support/shared_contexts/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end # h/t: https://stackoverflow.com/a/21851294/670433


#required_files = Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))]
#required_files += Dir[File.expand_path('support/shared_contexts/*.rb', File.dirname(__FILE__))]
#required_files.each do |file|
#  require file
#end # h/t: https://stackoverflow.com/a/21851294/670433





RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
