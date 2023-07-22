# frozen_string_literal: true

require "json"
require_relative "../behaviours/loggable"
require_relative "../behaviours/terminable"
require_relative "../behaviours/singletonnable"

module Objects
  # Object responsible for running a task.
  class Task
    include Behaviours::Loggable
    include Behaviours::Terminable
    extend Behaviours::Singletonnable

    # Start the task.
    #
    # @return [void]
    def start
      return if self.class.tasks_done.include?(task_name)

      log("Configuration of task : #{name}")
      log("Files that will be modified :\n#{files_modified.join(", ")}") unless files_modified.empty?
      log("Dependencies:\n#{config_dependencies}") unless config_dependencies.empty?
      log("Description :\n#{description}") unless description.nil?
      if terminal.prompt.yes?(
        "Do you want to run this task" \
        "#{dependencies.empty? ? "?" : " with the dependencies (#{dependencies.map(&:pretty_name).join(", ")})"}?"
      )
        dependencies.each do |dependency|
          log("", style: :none)
          log("Running task dependency #{dependency} ...")
          dependency.start
          success("Task dependency #{dependency} finished.")
          log("", style: :none)
        end
        log("Running task #{name} ...")
        run
        success("Task #{name} finished.")
        self.class.add_task_done(task_name)
        log("", style: :none)
      else
        log("Task aborted.")
      end
    rescue StandardError => e
      error("#{e.message}\n#{e.backtrace.join("\n")}")
    end

    # Return the pretty name of the task.
    #
    # This is required because Task.name is already used by Ruby.
    #
    # @return [String] The pretty name of the task.
    def pretty_name
      name
    end

    # Return whether the task is public or not.
    #
    # @return [Boolean] Whether the task is public or not.
    def public?
      true
    end

    private

      # Run the task.
      #
      # @return [void]
      def run
        raise NotImplementedError, "You must implement the run method in the #{self.class.name} class."
      end

      # Return the name of the task.
      #
      # @return [String] The name of the task.
      def name
        @name ||= config[:name]
      end

      # Return the name of the task.
      #
      # @return [String] The name of the task.
      def task_name
        @task_name ||= self.class.name.split("::")[-2]
      end

      # Return the description of the task.
      #
      # @return [String] The description of the task.
      def description
        @description ||= config[:description].is_a?(Array) ? config[:description].join("\n") : config[:description]
      end

      # Return the dependencies of the task found on the config.json file.
      #
      # @return [Array<String>] The dependencies of the task.
      def config_dependencies
        @dependencies ||= config[:dependencies].is_a?(Array) ? config[:dependencies].join("\n") : config[:dependencies]
      end

      # Return the dependencies of the task in terms of tasks.
      #
      # @return [Array<Objects::Task>] The dependencies of the task.
      def dependencies
        []
      end

      # Return the files that will be modified by the task.
      #
      # @return [Array<String>] The files that will be modified by the task.
      def files_modified
        @files_modified ||= config[:files_modified]
      end

      # Return the configuration of the task.
      #
      # @return [Hash] The configuration of the task.
      def config
        @config ||= JSON.parse(File.read(config_file_name), symbolize_names: true)
      end

      # Return the path to the config.json file.
      #
      # @return [String] The path to the config file.
      def config_file_name
        @config_file_name ||= begin
          path_to_task = self.class.name.split("::")[...-1].map do |part|
            part.gsub("::", "/")
                .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                .tr("-", "_")
                .downcase
          end.join("/")
          current_dir = File.dirname(__FILE__).split("/")[...-(path_to_task.split("/").size - 1)].join("/")
          "#{current_dir}/#{path_to_task}/config.json"
        end
      end

      class << self
        # Add a task to the list of tasks done.
        #
        # @param task_name [String] The name of the task.
        # @return [void]
        def add_task_done(task_name)
          tasks_done << task_name
        end

        # Return the list of tasks done.
        #
        # @return [Array<String>] The list of tasks done.
        def tasks_done
          @tasks_done ||= []
        end
      end
  end
end
