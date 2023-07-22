# frozen_string_literal: true

require "tty-prompt"
require "tty-command"
require_relative "../behaviours/loggable"
require_relative "../behaviours/singletonnable"

module Objects
  # Object responsible for using the terminal.
  class Terminal
    include Behaviours::Loggable
    extend Behaviours::Singletonnable

    attr_reader :prompt, :command

    def initialize
      @prompt = TTY::Prompt.new
      @command = TTY::Command.new
    end

    # Run a command.
    #
    # @param command_message [String] The command to run.
    # @param options [Hash] The options to run the command with.
    # @return [void]
    def run(command_message, **options)
      command.run(command_message, only_output_on_error: true, **options)
    end
  end
end
