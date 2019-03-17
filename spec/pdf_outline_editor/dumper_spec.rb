require 'json'

RSpec.describe PdfOutlineEditor::Dumper do
  let(:dumper) { described_class.new(input_pdf_path) }

  describe "#dump" do
    context "with a pdf file which has outlines" do
      let(:input_pdf_path) { path_for_asset('rails-with-toc.pdf') }
      let(:result) { JSON.parse(File.read(path_for_asset('rails.json'))) }

      it "returns outlines" do
        expect(dumper.dump).to eq(result)
      end
    end

    context "with a pdf file which doesn't have outlines" do
      let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }

      it "returns nil" do
        expect(dumper.dump).to be_nil
      end
    end
  end

  describe ".open" do
    let(:input_pdf_path) { path_for_asset('rails-with-toc.pdf') }

    before do
      PdfOutlineEditor::Dumper.open(input_pdf_path) do |dumper|
        @dumper = dumper
      end
    end

    it "closes dumper after yielding it" do
      expect(@dumper.closed).to eq(true)
    end
  end
end
