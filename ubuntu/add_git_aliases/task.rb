# frozen_string_literal: true

require_relative "../../objects/task"
require_relative "../../behaviours/fileable"
require_relative "../install_git/task"

module Ubuntu
  module AddGitAliases
    # Task responsible for adding git aliases.
    class Task < ::Objects::Task
      # Run the task.
      #
      # @return [void]
      def run
        log("Creating git aliases...")
        ALIASES.each do |alias_name, command|
          log("Creating alias '#{alias_name}' for command '#{command}'...")
          terminal.run("git config --global alias.#{alias_name} \"#{command}\"")
          success("Alias '#{alias_name}' created.")
        end
        success("Git aliases created.")
      end

      # Return the dependencies of the task.
      #
      # @return [Array<Objects::Task>] The dependencies of the task.
      def dependencies
        [::Ubuntu::InstallGit::Task]
      end

      ALIASES = {
        "co" => "checkout",
        "ci" => "commit",
        "st" => "status",
        "last" => "log -1 HEAD",
        "br" => "branch",
        "hist" => "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red)" \
                  "{{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short",
        "unstage" => "reset HEAD",
        "uncommit" => "reset --soft HEAD^",
        "alias" => "config --get-regexp ^alias.",
        "pl" => "pull",
        "cb" => "rev-parse --abbrev-ref HEAD",
        "spush" => "!git push -u origin HEAD"
      }.freeze
    end
  end
end
