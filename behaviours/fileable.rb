# frozen_string_literal: true

require_relative "terminable"

module Behaviours
  # Provides methods for interacting with files.
  module Fileable
    include Terminable

    # Reads the content of a file.
    #
    # @param filename [String] The name of the file.
    # @return [String] The content of the file.
    def read(filename:)
      File.read(filename)
    rescue StandardError
      terminal.run("cat #{filename.dump}").out || ""
    end

    # Writes content to a file.
    #
    # It writes the content to the file. If it fails,
    # it will use root permissions to write the content.
    #
    # @param filename [String] The name of the file.
    # @param content [String] The content to write to the file.
    # @return [void]
    def write(filename:, content:)
      File.write(filename, content)
    rescue StandardError
      terminal.run("echo #{content.dump} | sudo tee #{filename.dump}")
    end

    # Appends content to a file.
    #
    # It appends the content to the file. If it fails,
    # it will use root permissions to append the content.
    #
    # @param filename [String] The name of the file.
    # @param content [String] The content to append to the file.
    # @return [void]
    def append(filename:, content:)
      File.open(filename, "a") { |file| file.write(content) }
    rescue StandardError
      terminal.run("echo #{content.dump} | sudo tee -a #{filename.dump}")
      terminal.run("echo \"\\n\" | sudo tee -a #{filename.dump}")
    end
  end
end
