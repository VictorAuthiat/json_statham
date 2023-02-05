# frozen_string_literal: true

module JsonStatham
  module Helper
    class << self
      ["included", "extended"].each do |expand|
        define_method(expand) do |base|
          base.extend HelperMethod
          base.include HelperMethod
        end
      end
    end

    module HelperMethod
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
