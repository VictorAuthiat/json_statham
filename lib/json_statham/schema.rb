# frozen_string_literal: true

module JsonStatham
  class Schema
    attr_reader :object

    def self.call(object)
      new(object).call
    end

    def initialize(object)
      @object = object
    end

    def call
      return array_map if object.is_a?(Array)
      return transformed_hash if object.is_a?(Hash)

      object.class.name.downcase
    end

    def transformed_hash
      return unless object.is_a?(Hash)

      object
        .transform_keys(&:to_s)
        .transform_values { |obj| self.class.call(obj) }
    end

    def array_map
      return unless object.is_a?(Array)

      object.map { |obj| self.class.call(obj) }
    end
  end
end
