# frozen_string_literal: true

require_relative "../behaviours/terminable"

Dir.new("#{__dir__}/../ubuntu").each do |file|
  require_relative "../ubuntu/#{file}/task" unless file.match?(/^(\.)+$/)
end

module Companions
  # Provides methods for interacting with Ubuntu tasks.
  module Ubuntu
    extend Behaviours::Terminable
    class << self
      # Start the companion and display the list of tasks.
      #
      # @return [void]
      def start
        tasks
        terminal.prompt.multi_select("Which tasks do you want to run?", task_names).each do |task_name|
          task_from_name(task_name).start
        end
      end

      private

        # Return the list of tasks.
        #
        # @return [Array<Objects::Task>] The list of tasks.
        def tasks
          @tasks ||= ::Ubuntu.constants.filter_map do |c|
            ::Ubuntu.const_get(c)::Task if ::Ubuntu.const_get(c)::Task.public?
          end
        end

        # Return the list of task names.
        #
        # @return [Array<String>] The list of task names.
        def task_names
          @task_names ||= task_constants_map.keys
        end

        # Return the map of task names to task constants.
        #
        # @return [Hash] The map of task names to task constants.
        def task_constants_map
          @task_constants_map ||= tasks.to_h do |c|
            [c.pretty_name, c]
          end
        end

        # Return the task constant from the task name.
        #
        # @param task_name [String] The task name.
        # @return [Class] The task constant.
        def task_from_name(task_name)
          task_constants_map[task_name]
        end
    end
  end
end
