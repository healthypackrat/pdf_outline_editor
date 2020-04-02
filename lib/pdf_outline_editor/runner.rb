# frozen_string_literal: true

require 'optparse'

module PdfOutlineEditor
  class Runner
    class << self
      known_commands = {}

      define_method :known_commands do
        known_commands
      end

      define_method :register_command do |key, klass|
        known_commands[key] = klass
      end
    end

    def initialize(argv)
      @argv = argv

      @parser = nil

      parser.order!(@argv)
    end

    def run
      raise Error, "missing a command: available commands are #{Runner.known_commands.keys.sort.join(', ')}" if @argv.empty?

      command_name = @argv.shift

      command_class = Runner.known_commands[command_name.to_sym]

      raise Error, "unknown command: #{command_name}" unless command_class

      command = command_class.new(@argv)
      command.run
    end

    private

    def parser
      return @parser if @parser

      @parser = OptionParser.new

      @parser.banner = "Usage: #{File.basename($PROGRAM_NAME)} <command> <args>"

      @parser.version = VERSION

      @parser
    end
  end
end
