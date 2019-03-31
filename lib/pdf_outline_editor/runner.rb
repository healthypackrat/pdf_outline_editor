require 'optparse'

module PdfOutlineEditor
  class Runner
    class << self
      _known_commands = {}

      define_method :known_commands do
        _known_commands
      end

      define_method :register_command do |key, klass|
        _known_commands[key] = klass
      end
    end

    def initialize(argv)
      @argv = argv

      @parser = nil

      parser.order!(@argv)
    end

    def run
      if @argv.empty?
        raise Error, "missing a command: available commands are #{Runner.known_commands.keys.sort.join(', ')}"
      end

      command_name = @argv.shift

      command_class = Runner.known_commands[command_name.to_sym]

      if command_class
        command = command_class.new(@argv)
        command.run
      else
        raise Error, "unknown command: #{command_name}"
      end
    end

    private

    def parser
      return @parser if @parser

      @parser = OptionParser.new

      @parser.banner = "Usage: #{File.basename($0)} <command> <args>"

      @parser.version = VERSION

      @parser
    end
  end
end
