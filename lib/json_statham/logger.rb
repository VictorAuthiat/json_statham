# frozen_string_literal: true

module JsonStatham
  class Logger
    COL_LABELS = { file_path: "File path", duration: "Duration" }.freeze

    def config
      @_config = JsonStatham.config
    end

    def call
      log_header
      values.each { |hash| log_schema(hash) }
      log_divider
    end

    def columns
      @_columns ||= COL_LABELS.each_with_object({}) do |(col, label), hash|
        hash[col] = { label: label, width: [max_val(col), label.size].max }
      end
    end

    def max_val(col)
      values.map { |val| val[col].to_s.size }.max
    end

    def values
      @_values ||= Dir["#{config.schemas_path}/**/*.json"].map do |file_path|
        duration = JSON.parse(File.read(file_path))["duration"]

        { file_path: file_path, duration: duration }
      end
    end

    private

    def log_header
      log_divider
      puts "| #{columns.map { |_, col| col[:label].ljust(col[:width]) }.join(' | ')} |"
      log_divider
    end

    def log_divider
      puts "+-#{columns.map { |_, col| '-' * col[:width] }.join('-+-')}-+"
    end

    def log_schema(hash)
      puts "| #{hash.keys.map { |key| hash[key].to_s.ljust(columns[key][:width]) }.join(' | ')} |"
    end
  end
end
