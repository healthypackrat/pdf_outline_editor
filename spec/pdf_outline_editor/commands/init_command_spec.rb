RSpec.describe PdfOutlineEditor::Commands::InitCommand do
  let(:command) { described_class.new(argv) }

  describe "#output_format" do
    context "when -f option wasn't given" do
      let(:argv) { [] }

      it "returns :json" do
        expect(command.output_format).to eq(:json)
      end
    end

    context "when -f option was given with json" do
      let(:argv) { ['-f', 'json'] }

      it "returns :json" do
        expect(command.output_format).to eq(:json)
      end
    end

    context "when -f option was given with yaml" do
      let(:argv) { ['-f', 'yaml'] }

      it "returns :yaml" do
        expect(command.output_format).to eq(:yaml)
      end
    end
  end

  describe "#run" do
    let(:argv) { [] }

    it "outputs sample outlines" do
      expect { command.run }.to output(/"title": /).to_stdout
    end
  end
end
