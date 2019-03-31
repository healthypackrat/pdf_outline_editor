RSpec.describe PdfOutlineEditor::Runner do
  let(:runner) { described_class.new(argv) }

  describe "#run" do
    context "when argv is empty" do
      let(:argv) { [] }

      it "raises an error" do
        expect { runner.run }.to raise_error(PdfOutlineEditor::Error)
      end
    end

    context "when an unknown command was given" do
      let(:argv) { ['foo'] }

      it "raises an error" do
        expect { runner.run }.to raise_error(PdfOutlineEditor::Error)
      end
    end
  end
end
