# frozen_string_literal: true

require 'optparse'

module PdfOutlineEditor
  module Commands
    class InitCommand
      attr_reader :output_format

      def initialize(argv)
        @parser = nil

        @output_formats = %i[json yaml]
        @output_format = :json

        parser.parse!(argv)
      end

      def run
        sample_outlines = [
          {
            'title' => 'Chapter 1',
            'page' => 1,
            'children' => [
              {
                'title' => 'Section 1.1',
                'page' => 2
              }
            ]
          },
          {
            'title' => 'Chapter 2',
            'page' => 3
          }
        ]

        puts send("convert_to_#{@output_format}", sample_outlines)
      end

      private

      def parser
        return @parser if @parser

        @parser = OptionParser.new

        @parser.banner = "Usage: #{File.basename($PROGRAM_NAME)} init [options]"

        desc = "Output format (default: #{@output_format}; one of #{@output_formats.join(', ')})"
        @parser.on('-f', '--format=FORMAT', @output_formats, desc) do |value|
          @output_format = value.to_sym
        end

        @parser
      end

      def convert_to_json(outlines)
        require 'json'

        JSON.pretty_generate(outlines)
      end

      def convert_to_yaml(outlines)
        require 'yaml'

        YAML.dump(outlines)
      end

      Runner.register_command(:init, self)
    end
  end
end
