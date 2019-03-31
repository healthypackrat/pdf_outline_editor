require 'optparse'

module PdfOutlineEditor
  module Commands
    class DumpCommand
      attr_reader :output_format, :input_pdf_path

      def initialize(argv)
        @parser = nil

        @output_formats = [:json, :yaml]
        @output_format = :json

        @input_pdf_path = nil

        parser.parse!(argv)

        handle_args(argv)
      end

      def run
        Dumper.open(@input_pdf_path) do |dumper|
          outlines = dumper.dump

          if outlines
            puts send("convert_to_#{@output_format}", outlines)
          end
        end
      end

      private

      def parser
        return @parser if @parser

        @parser = OptionParser.new

        @parser.banner = "Usage: #{File.basename($0)} dump [options] <input-pdf-path>"

        desc = "Output format (default: #{@output_format}; one of #{@output_formats.join(', ')})"
        @parser.on('-f', '--format=FORMAT', @output_formats, desc) do |value|
          @output_format = value.to_sym
        end

        @parser
      end

      def handle_args(argv)
        @input_pdf_path = argv.shift
        raise Error, 'missing input pdf path' unless @input_pdf_path
      end

      def convert_to_json(outlines)
        require 'json'

        JSON.pretty_generate(outlines)
      end

      def convert_to_yaml(outlines)
        require 'yaml'

        YAML.dump(outlines)
      end

      Runner.register_command(:dump, self)
    end
  end
end
