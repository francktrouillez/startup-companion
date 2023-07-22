# frozen_string_literal: true

require_relative "../../objects/task"
require_relative "../../behaviours/fileable"
require_relative "../add_startup_script/task"

module Ubuntu
  module AddMysqlDockerImage
    # Task responsible for adding mysql docker image.
    class Task < Objects::Task
      include Behaviours::Fileable

      # Run the task.
      #
      # @return [void]
      def run
        log("Adding mysql docker image...")
        terminal.run("sudo docker pull mysql/mysql-server:latest")
        success("mysql docker image added.")
        begin
          terminal.run(
            "docker run -d -p 3306:3306 --name mysql-docker-container -e MYSQL_ROOT_PASSWORD=root " \
            "-e MYSQL_DATABASE=localhost -e MYSQL_USER=root -e MYSQL_PASSWORD=root " \
            "mysql/mysql-server:latest 1&>&2"
          )
        rescue StandardError
          log("mysql docker container already exists.")
        end
        command = "docker start mysql-docker-container"
        if read(filename: "#{Dir.home}/.startup").split("/n").any? { |line| line.include?(command) }
          log("#{command.dump} already in ~/.startup.")
        else
          log("Adding #{command.dump} to ~/.startup ...")
          append(
            filename: "#{Dir.home}/.startup",
            content: command
          )
          success("#{command.dump} added to ~/.startup.")
        end
        success("mysql docker container included in startup.")
      end

      # Return the dependencies of the task.
      #
      # @return [Array<Objects::Task>] The dependencies of the task.
      def dependencies
        [
          ::Ubuntu::AddStartupScript::Task
        ]
      end
    end
  end
end
