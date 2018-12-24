
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "my_banner/version"

Gem::Specification.new do |spec|
  spec.name          = "my_banner"
  spec.version       = MyBanner::VERSION
  spec.authors       = ["MJ Rossetti"]
  spec.email         = ["prof.mj.rossetti@gmail.com", "mjr300@georgetown.edu"]

  spec.summary       = "This program processes detailed schedule information from your school's Ellucian Banner information system to generate Google Calendar events and/or Google Sheets gradebook files for each of your scheduled classes."
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/prof-rossetti/my-banner-rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.2"
  spec.add_dependency "google-api-client", "~> 0.27"
  spec.add_dependency "nokogiri", '~> 1.9'
  spec.add_dependency "pry" # really just for development purposes

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "factory_bot", "~> 4.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.4"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "simplecov-console", "~> 0.4"
end
