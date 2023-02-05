# frozen_string_literal: true

module JsonStatham
  module Requests
    class Reader < Base
      def call
        return {} unless File.exist?(file_path)

        JSON.parse(File.read(file_path))
      rescue JSON::ParserError
        {}
      end
    end
  end
end
