# frozen_string_literal: true

module JsonStatham
  class Config
    attr_reader :schemas_path, :store_schema, :raise_ratio

    def initialize
      @schemas_path = nil
      @store_schema = nil
      @raise_ratio  = nil
    end

    def store_schema?
      !!store_schema
    end

    def schemas_path_present?
      !!schemas_path
    end

    def raise_on_failure?
      !!raise_ratio
    end

    def schemas_path=(value)
      Validation.check_object_class(value, [String])

      @schemas_path = value
    end

    def store_schema=(value)
      Validation.check_object_class(value, [TrueClass, FalseClass, NilClass])

      @store_schema = value
    end

    def raise_ratio=(value)
      Validation.check_object_class(value, [Integer])

      @raise_ratio = value
    end
  end
end
