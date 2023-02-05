# frozen_string_literal: true

require_relative "json_statham/helper"
require_relative "json_statham/version"
require_relative "json_statham/validation"
require_relative "json_statham/requests"

module JsonStatham
  autoload :Config, "json_statham/config"
  autoload :Parser, "json_statham/parser"
  autoload :Schema, "json_statham/schema"

  class << self
    def configure
      yield config
    end

    def config
      @_config ||= Config.new
    end

    def extended(base)
      base.include Helper
    end
  end
end
