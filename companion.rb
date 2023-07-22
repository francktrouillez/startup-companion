# frozen_string_literal: true

require_relative "behaviours/loggable"
require_relative "behaviours/terminable"

Dir.new("#{__dir__}/companions").each do |file|
  require_relative "companions/#{file}" if file.match?(/\.rb$/)
end

# Object responsible for running the companion.
module Companion
  extend Behaviours::Loggable
  extend Behaviours::Terminable

  AVAILABLE_OS = %i[ubuntu].freeze

  class << self
    # Start the companion.
    #
    # @return [void]
    def start
      os = terminal.prompt.select("What is your OS?", AVAILABLE_OS)
      Companions.const_get(os.to_s.split("_").map(&:capitalize).join).start
    rescue StandardError => e
      error("#{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
