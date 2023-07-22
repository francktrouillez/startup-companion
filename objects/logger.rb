# frozen_string_literal: true

require_relative "styles"
require_relative "../behaviours/singletonnable"

module Objects
  # Object responsible for logging.
  class Logger
    class UnknownStyleError < StandardError; end
    extend Behaviours::Singletonnable

    ALLOWED_STYLES = %i[info warn error success none].freeze

    def initialize(prefix: "", include_datetime: false, show_severity: true, style: nil)
      @prefix = prefix
      @include_datetime = include_datetime
      @show_severity = show_severity
      @instance_style = style
    end

    # Log a message with the given style.
    #
    # @param message [String] The message to log.
    # @param style [Symbol] The style to use.
    # @return [void]
    def log(message, style: :info)
      style = instance_style || style
      raise UnknownStyleError unless ALLOWED_STYLES.include?(style)

      lines = message.to_s.split("\n")
      style == :none ? puts(lines.shift) : log_line(lines.shift, style)

      lines.each do |line|
        style == :none ? puts(line) : log_line(line, style, skip_severity: true)
      end
    end

    private

      attr_reader :prefix, :include_datetime, :show_severity, :instance_style

      # Log a line with the given style.
      #
      # @param message [String] The message to log.
      # @param style [Symbol] The style to use.
      # @param skip_severity [Boolean] Skip the severity flag.
      # @return [void]
      def log_line(message, style, skip_severity: false)
        print Styles.default.call("#{prefix} - ") unless prefix.empty?
        print Styles.default.call("#{Time.now} - ") if include_datetime
        if show_severity
          severity_flag = "[#{style.upcase}]"
          print Styles.send(style).call("#{skip_severity ? " " * severity_flag.size : severity_flag} ")
          print Styles.default.call(message)
        else
          print Styles.send(style).call(message)
        end
        puts
      end
  end
end
