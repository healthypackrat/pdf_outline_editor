require 'json'
require 'tempfile'

RSpec.describe PdfOutlineEditor::Loader do
  let(:loader) { PdfOutlineEditor::Loader.new(input_pdf_path) }

  describe "#initialize" do
    context "with non-existent input pdf path" do
      let(:input_pdf_path) { path_for_asset('not-found.pdf') }

      it "raises an error" do
        expect { loader }.to raise_error(PdfOutlineEditor::Error)
      end
    end
  end

  describe "#load" do
    context "with valid data" do
      let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }
      let(:entries) { JSON.parse(File.read(path_for_asset('rails.json'))) }
      let(:output_file) { Tempfile.open(['', '.pdf']) }
      let(:dumper) { PdfOutlineEditor::Dumper.new(output_file.path) }

      before do
        loader.load(entries)
        loader.save(output_file.path)
      end

      it "loads outlines" do
        expect(dumper.dump).to eq(entries)
      end

      after do
        output_file.close
        dumper.close
        loader.close
      end
    end

    context "with too large page number" do
      let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }
      let(:entries) { [{ 'title' => 'Some Title', 'page' => 45 }] }

      it "raises an error" do
        expect { loader.load(entries) }.to raise_error(PdfOutlineEditor::Error)
      end

      after do
        loader.close
      end
    end
  end

  describe ".open" do
    let(:input_pdf_path) { path_for_asset('rails-without-toc.pdf') }

    before do
      PdfOutlineEditor::Loader.open(input_pdf_path) do |loader|
        @loader = loader
      end
    end

    it "closes loader after yielding it" do
      expect(@loader.closed).to eq(true)
    end
  end
end
