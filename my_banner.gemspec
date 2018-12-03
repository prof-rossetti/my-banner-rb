
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "my_banner/version"

Gem::Specification.new do |spec|
  spec.name          = "my_banner"
  spec.version       = MyBanner::VERSION
  spec.authors       = ["MJ Rossetti"]
  spec.email         = ["prof.mj.rossetti@gmail.com", "mjr300@georgetown.edu"]

  spec.summary       = %q{Generates Google Calendar schedules and Google Sheet rosters for all your classes.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/prof-rossetti/my-banner-rb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", '~> 5.2'
  spec.add_dependency "google-api-client", '~> 0.8'
  spec.add_dependency "pry"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "factory_bot", "~> 4.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.4"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
