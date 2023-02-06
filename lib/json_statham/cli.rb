# frozen_string_literal: true

require "thor"

module JsonStatham
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    class_option :schemas_path,
                 type: :string,
                 desc: "JsonStatham schemas path",
                 required: true

    desc "ls", "List json files"
    map "-L" => :list

    def list
      configure_json_statham
      display_header

      Dir["./#{schemas_path}/**/*.json"].each do |file_path|
        parser   = JsonStatham::Parser.new(file_path)
        reader   = JsonStatham::Requests::Reader.new(parser).call(file_path)
        duration = reader["duration"]

        puts "#{file_path}                    #{duration.round(12)}"
      end

      puts
    end

    def schemas_path
      @_schemas_path ||= options["schemas_path"]
    end

    private

    def configure_json_statham
      JsonStatham.configure { |c| c.schemas_path = schemas_path }
    end

    def display_header
      puts
      puts "file_path                             duration"
      puts "----------------------------------------------"
    end
  end
end
