# frozen_string_literal: true

require "pastel"

module Objects
  # Provides styles for logging.
  module Styles
    class << self
      # Return the info style.
      #
      # @return [Proc] The info style.
      def info
        @info ||= pastel.blue.detach
      end

      # Return the warn style.
      #
      # @return [Proc] The warn style.
      def warn
        @warn ||= pastel.yellow.detach
      end

      # Return the error style.
      #
      # @return [Proc] The error style.
      def error
        @error ||= pastel.red.detach
      end

      # Return the success style.
      #
      # @return [Proc] The success style.
      def success
        @success ||= pastel.green.detach
      end

      # Return the default style.
      #
      # @return [Proc] The default style.
      def default
        @default ||= pastel.detach
      end

      private

        # Return the pastel object.
        #
        # @return [Pastel] The pastel object.
        def pastel
          @pastel ||= Pastel.new
        end
    end
  end
end
