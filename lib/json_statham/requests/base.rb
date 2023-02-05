# frozen_string_literal: true

require "forwardable"

module JsonStatham
  module Requests
    class Base
      extend Forwardable

      attr_reader :parser

      def_delegators :@parser, :name, :block, :current_schema, :observer

      def_delegators :@config, :schemas_path

      def self.call(parser)
        new(parser).call
      end

      def initialize(parser)
        Validation.check_object_class(parser, [JsonStatham::Parser])

        @parser = parser
        @config = JsonStatham.config
      end

      def base_path
        return "#{schemas_path}/#{folder_path}" if !!folder_path

        schemas_path
      end

      def file_path
        "#{base_path}/#{schema_name}.json"
      end

      def schema_name
        splitted_name.last
      end

      def folder_path
        return if splitted_name.length == 1

        splitted_name.reverse.drop(1).reverse.join("/")
      end

      def splitted_name
        name.split("/")
      end

      def schema_name
        splitted_name.last
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
