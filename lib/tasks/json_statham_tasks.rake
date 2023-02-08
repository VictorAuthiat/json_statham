# frozen_string_literal: true

namespace :statham do
  task log_files_duration: :environment do
    JsonStatham::Logger.new.call
  end
end

task json_statham: ["statham:log_files_duration"]
