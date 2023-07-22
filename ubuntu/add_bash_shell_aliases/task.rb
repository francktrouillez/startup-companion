# frozen_string_literal: true

require_relative "../../behaviours/fileable"
require_relative "../../objects/task"
require_relative "../install_colordiff/task"
require_relative "../install_net_tools/task"

module Ubuntu
  module AddBashShellAliases
    # Task responsible for adding bash shell aliases.
    class Task < Objects::Task
      include Behaviours::Fileable

      # Run the task.
      #
      # @return [void]
      def run
        log("Creating bash shell aliases...")
        log("Checking current aliases in .bash_aliases ...")
        current_bash_aliases = read(filename: "#{Dir.home}/.bash_aliases")
        current_aliases = current_bash_aliases.split("\n").filter_map do |alias_line|
          alias_line.match(/alias\s(.*)='(.*)'/)&.captures&.first
        end

        new_aliases = ALIASES.filter_map do |alias_name, command|
          next if current_aliases.include?(alias_name)

          "alias #{alias_name}='#{command}'"
        end
        if new_aliases.empty?
          log("No new aliases to add to .bash_aliases.")
        else
          log("Adding new aliases to .bash_aliases ...")
          new_aliases.each do |alias_line|
            log("Adding '#{alias_line}' to .bash_aliases ...")

            append(filename: "#{Dir.home}/.bash_aliases", content: alias_line)
          end
          success("New aliases added to .bash_aliases.")
        end

        log("Check for 'source ~/.bash_aliases' in your ~/.bashrc file")
        current_bashrc = read(filename: "#{Dir.home}/.bashrc")
        if current_bashrc.split("\n").any? do |line|
          line.include?("source ~/.bash_aliases") ||
          line.include?(". ~/.bash_aliases")
        end
          log("'source ~/.bash_aliases' already in ~/.bashrc.")
        else
          log("Adding 'source ~/.bash_aliases' to ~/.bashrc ...")
          append(filename: "#{Dir.home}/.bashrc", content: "source ~/.bash_aliases")
          success("'source ~/.bash_aliases' added to ~/.bashrc.")
        end
        success("Bash shell aliases created.")
      end

      # Return the dependencies of the task.
      #
      # @return [Array<Objects::Task>] The dependencies of the task.
      def dependencies
        [
          Ubuntu::InstallColordiff::Task,
          Ubuntu::InstallNetTools::Task
        ]
      end

      ALIASES = {
        "ls" => "ls --color=auto",
        "ll" => "ls -la",
        "l." => "ls -d .* --color-auto",
        "c" => "clear",
        "cd.." => "cd ..",
        ".." => "cd ..",
        "..." => "cd ../../",
        "...." => "cd ../../../",
        "....." => "cd ../../../../",
        ".4" => "cd ../../../../",
        ".5" => "cd ../../../../../",
        "grep" => "grep --color=auto",
        "fgrep" => "fgrep --color=auto",
        "egrep" => "egrep --color=auto",
        "sha1" => "openssl sha1",
        "diff" => "colordiff",
        "h" => "history",
        "now" => "date +\"%Y-%m-%d %T\"",
        "ping" => "ping -c 5",
        "fastping" => "ping -c 25 -i .2",
        "ports" => "netstat -tulanp",
        "header" => "curl -I",
        "apt" => "sudo apt",
        "apt-get" => "sudo apt-get",
        "update" => "sudo apt-get update && sudo apt-get upgrade",
        "root" => "sudo -i",
        "su" => "sudo -i",
        "meminfo" => "free -m -l -t",
        "cpuinfo" => "lscpu",
        "wget" => "wget -c",
        "k" => "kill -9"
      }.freeze
    end
  end
end
