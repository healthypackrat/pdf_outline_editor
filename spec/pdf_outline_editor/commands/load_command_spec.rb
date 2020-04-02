# frozen_string_literal: true

require 'json'
require 'tempfile'
require 'yaml'

RSpec.describe PdfOutlineEditor::Commands::LoadCommand do
  let(:command) { described_class.new(argv) }

  let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }
  let(:json_input_outlines_path) { path_for_asset('rails.json') }
  let(:yaml_input_outlines_path) { path_for_asset('rails.yaml') }
  let(:output_file) { Tempfile.new(['', '.pdf']) }
  let(:output_pdf_path) { output_file.path }

  after do
    output_file.close
  end

  context 'when an input pdf path was not given' do
    let(:argv) { [] }

    it 'raises an error' do
      expect { command }.to raise_error(PdfOutlineEditor::Error)
    end
  end

  context 'when an input outlines path was not given' do
    let(:argv) { [input_pdf_path] }

    it 'raises an error' do
      expect { command }.to raise_error(PdfOutlineEditor::Error)
    end
  end

  context 'when an output pdf path was not given' do
    let(:argv) { [input_pdf_path, json_input_outlines_path] }

    it 'raises an error' do
      expect { command }.to raise_error(PdfOutlineEditor::Error)
    end
  end

  describe '#run' do
    context 'with JSON outlines' do
      let(:argv) { [input_pdf_path, json_input_outlines_path, output_pdf_path] }

      let(:parsed_outlines) { JSON.parse(File.read(json_input_outlines_path)) }

      let(:dumped_outlines) { PdfOutlineEditor::Dumper.open(output_pdf_path, &:dump) }

      before do
        command.run
      end

      it 'generates a pdf file with given outlines' do
        expect(dumped_outlines).to eq(parsed_outlines)
      end
    end

    context 'with YAML outlines' do
      let(:argv) { [input_pdf_path, yaml_input_outlines_path, output_pdf_path] }

      let(:parsed_outlines) { YAML.load_file(yaml_input_outlines_path) }

      let(:dumped_outlines) { PdfOutlineEditor::Dumper.open(output_pdf_path, &:dump) }

      before do
        command.run
      end

      it 'generates a pdf file with given outlines' do
        expect(dumped_outlines).to eq(parsed_outlines)
      end
    end
  end
end
