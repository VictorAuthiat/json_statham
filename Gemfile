# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in json_statham.gemspec
gemspec

gem "rake", "~> 13.0"

gem "rspec", "~> 3.0"

gem "rubocop", "~> 1.21"

gem "pry", "~> 0.14.2"

gem "simplecov", "~> 0.22.0"

gem "rails", "~> 6.1.7.1"

case RUBY_VERSION.split(".").first
when "3"
  gem "net-smtp", require: false
end

group :test do
  gem "generator_spec"
  gem "rspec-rails"
end
