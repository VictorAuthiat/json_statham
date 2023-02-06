# frozen_string_literal: true

module JsonStatham
  class Parser
    attr_reader :name, :block, :reader, :observer

    def self.call(name, &block)
      new(name, &block).call
    end

    def initialize(name, &block)
      Validation.check_object_class(name, [String])

      @name  = name
      @block = block
    end

    def call
      @reader   = JsonStatham::Requests::Reader.call(self)
      @observer = JsonStatham::Requests::Observer.call(self)

      store_current_schema

      JsonStatham::Result.call(self)
    end

    def store_current_schema
      return unless JsonStatham.config.store_schema?

      JsonStatham::Requests::Writer.call(self)
    end

    def schema
      observer&.data
    end

    def stored_schema
      return unless reader?

      reader["schema"]
    end

    def previous_duration
      return unless reader?

      reader["duration"]
    end

    def reader?
      !!reader
    end

    def current_schema
      JsonStatham::Schema.call(schema)
    end

    def stored_schema?
      !!stored_schema
    end

    def valid?
      !stored_schema? || (stored_schema == current_schema)
    end
  end
end
