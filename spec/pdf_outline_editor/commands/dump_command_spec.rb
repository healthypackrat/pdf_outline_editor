# frozen_string_literal: true

RSpec.describe PdfOutlineEditor::Commands::DumpCommand do
  let(:command) { described_class.new(argv) }

  context 'when argv is empty' do
    let(:argv) { [] }

    it 'raises an error' do
      expect { command }.to raise_error(PdfOutlineEditor::Error)
    end
  end

  context 'when a input pdf path which has outlines was given' do
    let(:input_pdf_path) { path_for_asset('rails-with-toc.pdf') }

    context 'when no -f option was given' do
      let(:argv) { [input_pdf_path] }

      describe '#output_format' do
        it 'returns :json' do
          expect(command.output_format).to eq(:json)
        end
      end

      describe '#input_pdf_path' do
        it 'returns given input pdf path' do
          expect(command.input_pdf_path).to eq(input_pdf_path)
        end
      end

      describe '#run' do
        it 'outputs JSON' do
          expect { command.run }.to output(/"title":/).to_stdout
        end
      end
    end

    context 'when -f option was given with json' do
      let(:argv) { ['-f', 'json', input_pdf_path] }

      describe '#output_format' do
        it 'returns :json' do
          expect(command.output_format).to eq(:json)
        end
      end

      describe '#run' do
        it 'outputs JSON' do
          expect { command.run }.to output(/"title": /).to_stdout
        end
      end
    end

    context 'when -f option was given with yaml' do
      let(:argv) { ['-f', 'yaml', input_pdf_path] }

      describe '#output_format' do
        it 'returns :yaml' do
          expect(command.output_format).to eq(:yaml)
        end
      end

      describe '#run' do
        it 'outputs YAML' do
          expect { command.run }.to output(/title: /).to_stdout
        end
      end
    end
  end

  context "when a input pdf path which doesn't have outlines was given" do
    let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }
    let(:argv) { [input_pdf_path] }

    describe '#run' do
      it "doesn't output anything" do
        expect { command.run }.to output('').to_stdout
      end
    end
  end
end
