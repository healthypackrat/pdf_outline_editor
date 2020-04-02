# frozen_string_literal: true

require 'optparse'

module PdfOutlineEditor
  module Commands
    class LoadCommand
      def initialize(argv)
        @parser = nil

        @input_pdf_path = nil
        @outlines = nil
        @output_pdf_path = nil

        parser.parse!(argv)

        handle_args(argv)
      end

      def run
        Loader.open(@input_pdf_path) do |loader|
          loader.load(@outlines)
          loader.save(@output_pdf_path)
        end
      end

      private

      def parser
        return @parser if @parser

        @parser = OptionParser.new

        @parser.banner = "Usage: #{File.basename($PROGRAM_NAME)} load <input-pdf-path> <input-outlines-path> <output-pdf-path>"

        @parser
      end

      def handle_args(argv)
        @input_pdf_path = argv.shift

        raise Error, 'missing input pdf path' unless @input_pdf_path

        input_outlines_path = argv.shift

        raise Error, 'missing input outlines path' unless input_outlines_path

        @outlines = parse_outlines(input_outlines_path)

        @output_pdf_path = argv.shift

        raise Error, 'missing output pdf path' unless @output_pdf_path
      end

      def parse_outlines(path)
        ext = File.extname(path)[1..-1]

        method_name = "parse_#{ext}_outlines"

        raise Error, "unknown extension: #{ext}" unless respond_to?(method_name, true)

        send(method_name, path)
      end

      def parse_json_outlines(path)
        require 'json'

        JSON.parse(File.read(path))
      end

      def parse_yaml_outlines(path)
        require 'yaml'

        YAML.load_file(path)
      end

      def parse_yml_outlines(path)
        parse_yaml_outlines(path)
      end

      Runner.register_command(:load, self)
    end
  end
end
