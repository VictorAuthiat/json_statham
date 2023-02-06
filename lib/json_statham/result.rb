# frozen_string_literal: true

module JsonStatham
  class Result
    attr_reader :parser

    def self.call(parser)
      new(parser).call
    end

    def initialize(parser)
      Validation.check_object_class(parser, [JsonStatham::Parser])

      @parser = parser
    end

    def call
      if JsonStatham.config.logger?
        puts <<-RESULT_MSG
          Previous duration: #{previous_duration}
          Current duration: #{current_duration}
        RESULT_MSG
      end

      self
    end

    def current_duration
      return unless observed?

      parser.observer.duration
    end

    def observed?
      !!parser.observer
    end

    def previous_duration
      parser.previous_duration
    end

    def success?
      parser.valid?
    end

    def failure?
      !success?
    end
  end
end
