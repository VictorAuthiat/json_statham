# frozen_string_literal: true

module JsonStatham
  class Config
    attr_reader :schemas_path, :store_schema, :logger

    def initialize
      @schemas_path = nil
      @store_schema = nil
      @logger       = nil
    end

    def store_schema?
      !!store_schema
    end

    def logger?
      !!logger
    end

    def schemas_path_present?
      !!schemas_path
    end

    def schemas_path=(value)
      Validation.check_object_class(value, [String])

      @schemas_path = value
    end

    def store_schema=(value)
      Validation.check_object_class(value, [TrueClass, FalseClass, NilClass])

      @store_schema = value
    end

    def logger=(value)
      Validation.check_object_class(value, [TrueClass, FalseClass, NilClass])

      @logger = value
    end
  end
end
