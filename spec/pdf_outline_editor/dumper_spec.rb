require 'json'

RSpec.describe PdfOutlineEditor::Dumper do
  let(:dumper) { PdfOutlineEditor::Dumper.new(input_pdf_path) }

  describe "#initialize" do
    context "with non-existent input pdf path" do
      let(:input_pdf_path) { path_for_asset('not-found.pdf') }

      it "raises an error" do
        expect { dumper }.to raise_error(PdfOutlineEditor::Error)
      end
    end
  end

  describe "#dump" do
    context "with a pdf file which has outlines" do
      let(:input_pdf_path) { path_for_asset('rails-with-toc.pdf') }
      let(:result) { JSON.parse(File.read(path_for_asset('rails.json'))) }

      it "returns outlines" do
        expect(dumper.dump).to eq(result)
      end

      after do
        dumper.close
      end
    end

    context "with a pdf file which doesn't have outlines" do
      let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }

      it "returns nil" do
        expect(dumper.dump).to be_nil
      end

      after do
        dumper.close
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
