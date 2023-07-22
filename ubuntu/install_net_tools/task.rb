# frozen_string_literal: true

require_relative "../../objects/task"
module Ubuntu
  module InstallNetTools
    # Task responsible for installing net-tools.
    class Task < Objects::Task
      # Run the task.
      #
      # @return [void]
      def run
        log("Installing colordiff...")
        terminal.run("sudo apt-get install net-tools -y")
        success("colordiff installed.")
      end

      # Return whether the task is public.
      #
      # This task was added because it was a dependency of another task.
      # That's why it's not public.
      #
      # @return [Boolean] Whether the task is public.
      def public?
        false
      end
    end
  end
end
