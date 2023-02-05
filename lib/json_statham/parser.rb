# frozen_string_literal: true

module JsonStatham
  class Parser
    attr_reader :name, :block

    def initialize(name, &block)
      Validation.check_object_class(name, [String])

      @name  = name
      @block = block
    end

    def schema
      @_schema ||= observer.data
    end

    def observer
      @_observer ||= JsonStatham::Requests::Observer.call(self)
    end

    def reader
      @_reader ||= JsonStatham::Requests::Reader.call(self)
    end

    def stored_schema
      reader["schema"]
    end

    def previous_duration
      reader["duration"]
    end

    def store_schema
      JsonStatham::Requests::Writer.call(self)
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
