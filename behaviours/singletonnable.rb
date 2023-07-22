# frozen_string_literal: true

require_relative "../objects/logger"

module Behaviours
  # Allow an object to be a singleton.
  module Singletonnable
    # Redirect all the methods missing to the instance.
    #
    # If the keywords arguments are not supported, the last argument is
    # considered as a hash.
    #
    # @param method [Symbol] The method name.
    # @param args [Array] The arguments.
    # @param block [Proc] The block.
    # @return [void]
    def method_missing(method, *args, &)
      instance.send(method, *args, &)
    rescue ArgumentError
      instance.send(method, *args[...-1], **args[-1], &)
    end

    # Check if the method is supported by the instance.
    #
    # Definition required to avoid warning on method_missing
    # asking for respond_to_missing?.
    #
    # @param method [Symbol] The method name.
    # @param include_private [Boolean] Include private methods.
    # @return [Boolean] True if the method is supported, false otherwise.
    def respond_to_missing?(method, include_private = false)
      super
    end

    private

      # Return the instance of the singleton.
      #
      # @return [Object] The instance.
      def instance
        @instance ||= new
      end
  end
end
