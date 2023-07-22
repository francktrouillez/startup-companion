# frozen_string_literal: true

require_relative "../objects/terminal"

module Behaviours
  # Provides methods for interacting with the terminal.
  module Terminable
    private

      # Return the terminal object.
      #
      # @return [Objects::Terminal] The terminal object.
      def terminal
        Objects::Terminal
      end
  end
end
