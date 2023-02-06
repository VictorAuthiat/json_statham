# frozen_string_literal: true

module JsonStatham
  module Requests
    class Reader < Base
      def call(path = nil)
        path ||= file_path

        return {} unless File.exist?(path)

        JSON.parse(File.read(path))
      rescue JSON::ParserError
        {}
      end
    end
  end
end
