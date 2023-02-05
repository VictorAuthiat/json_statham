# frozen_string_literal: true

require "json"

module JsonStatham
  module Requests
    autoload :Base,     "json_statham/requests/base"
    autoload :Writer,   "json_statham/requests/writer"
    autoload :Reader,   "json_statham/requests/reader"
    autoload :Observer, "json_statham/requests/observer"
  end
end
