# frozen_string_literal: true

module JsonStatham
  module Requests
    class Writer < Base
      def call
        FileUtils.mkdir_p(base_path)

        File.write(file_path, JSON.dump(dump))
      end

      def dump
        { schema: current_schema, duration: observer.duration }
      end
    end
  end
end
