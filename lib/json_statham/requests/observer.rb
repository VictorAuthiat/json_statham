# frozen_string_literal: true

module JsonStatham
  module Requests
    class Observer < Base
      attr_reader :starting, :ending, :data, :duration

      def self.clock_gettime
        Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_second)
      end

      def call
        @starting = clock_gettime
        @data     = block.call
        @ending   = clock_gettime
        @duration = ending - starting

        self
      end

      def clock_gettime
        self.class.clock_gettime
      end
    end
  end
end
