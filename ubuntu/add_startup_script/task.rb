# frozen_string_literal: true

require_relative "../../objects/task"
module Ubuntu
  module AddStartupScript
    # Task responsible for adding startup script.
    class Task < Objects::Task
      # Run the task.
      #
      # @return [void]
      def run
        log("Adding startup script...")
        terminal.run("touch #{Dir.home}/.startup")
        terminal.run("chmod +x #{Dir.home}/.startup")
        success("Startup script added.")
        log("Check for 'startup' in your crontab file")
        cronjob = "@reboot #{Dir.home}/.startup"
        if terminal.run("crontab -l").out.split("\n").include?(cronjob)
          log("#{cronjob.dump} already in crontab.")
        else
          terminal.run("(crontab -l && echo #{cronjob.dump}) | crontab -")
          log("#{cronjob.dump} added to crontab.")
        end
        success("Cronjob added.")
      end
    end
  end
end
