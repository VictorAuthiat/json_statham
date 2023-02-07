# frozen_string_literal: true

module JsonStatham
  class InvalidRatioError < StandardError
  end

  class Result
    attr_reader :parser, :config

    def self.call(parser)
      new(parser).call
    end

    def initialize(parser)
      Validation.check_object_class(parser, [JsonStatham::Parser])

      @parser = parser
      @config = JsonStatham.config
    end

    def call
      ensure_valid_ratio
      log_result

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

    def previous_duration?
      !!previous_duration
    end

    def success?
      parser.valid?
    end

    def failure?
      !success?
    end

    def ratio
      return 0 unless observed?

      current_duration.fdiv(previous_duration)
    end

    def limit_ratio
      config.raise_ratio
    end

    def ensure_valid_ratio
      return unless config.raise_on_failure? && previous_duration? && ratio > limit_ratio

      raise JsonStatham::InvalidRatioError, "limit_ratio: #{limit_ratio}. current_ratio: #{ratio}"
    end

    private

    def log_result
      return unless JsonStatham.config.logger?

      puts "Previous duration: #{previous_duration} Current duration: #{current_duration}"
    end
  end
end
