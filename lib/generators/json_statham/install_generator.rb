# frozen_string_literal: true

require "rails/generators"

module JsonStatham
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_initializer
      template "json_statham.rb", "config/initializers/json_statham.rb"
    end
  end
end
