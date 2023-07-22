# frozen_string_literal: true

require_relative "../objects/logger"

module Behaviours
  # Provides methods for logging.
  module Loggable
    # Log a message with the given style.
    #
    # @param message [String] The message to log.
    # @param style [Symbol] The style to use.
    # @return [void]
    def log(message, style: :info)
      logger.log(message, style:)
    end

    # Log an error message.
    #
    # @param message [String] The message to log.
    # @return [void]
    def error(message)
      log(message, style: :error)
    end

    # Log a warning message.
    #
    # @param message [String] The message to log.
    # @return [void]
    def warn(message)
      log(message, style: :warn)
    end

    # Log a success message.
    #
    # @param message [String] The message to log.
    # @return [void]
    def success(message)
      log(message, style: :success)
    end

    private

      # Get the logger.
      #
      # @return [Objects::Logger]
      def logger
        Objects::Logger
      end
  end
end
