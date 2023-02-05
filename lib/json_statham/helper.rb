# frozen_string_literal: true

module JsonStatham
  module Helper
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def with_schema(name, &block)
        parser = JsonStatham::Parser.new(name, &block)
        previous_duration = parser.previous_duration
        parser.store_schema if JsonStatham.config.store_schema?
        return unless JsonStatham.config.logger?

        show_result(parser.observer.duration, previous_duration)
      end

      private

      def show_result(current_duration, previous_duration)
        puts "Previous duration: #{current_duration}"
        puts "Current duration: #{previous_duration}"
      end
    end
  end
end
