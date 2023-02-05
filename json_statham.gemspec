# frozen_string_literal: true

require_relative "lib/json_statham/version"

Gem::Specification.new do |spec|
  spec.name    = "json_statham"
  spec.version = JsonStatham::VERSION
  spec.authors = ["Victor"]
  spec.email   = ["authiatv@gmail.com"]

  spec.summary     = "Check for json schema changes during a migration"
  spec.description = "Check for json schema changes during a migration"
  spec.homepage    = "https://github.com/victorauthiat/json_statham"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
