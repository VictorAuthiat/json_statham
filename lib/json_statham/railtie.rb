# frozen_string_literal: true

module JsonStatham
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/json_statham_tasks.rake', __dir__)
    end
  end
end
