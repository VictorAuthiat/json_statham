# frozen_string_literal: true

module JsonStatham
  module Helper
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def stathamnize(name, &block)
        ensure_valid_config

        JsonStatham::Parser.call(name, &block)
      end

      private

      def ensure_valid_config
        return if JsonStatham.config.schemas_path_present?

        raise ArgumentError, "JsonStatham::Config#chemas_path can't be blank."
      end
    end
  end
end
