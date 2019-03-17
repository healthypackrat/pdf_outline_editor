module PdfOutlineEditor
  class Loader
    java_import org.apache.pdfbox.pdmodel.PDDocument
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageXYZDestination
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem

    JavaFile = java.io.File

    def self.open(input_pdf_path)
      loader = new(input_pdf_path)

      begin
        yield loader
      ensure
        loader.close
      end
    end

    attr_reader :closed

    def initialize(input_pdf_path)
      @doc = PDDocument.load(JavaFile.new(input_pdf_path))
      @pages = @doc.pages.to_a
      @closed = false
    end

    def load(entries)
      root_outline =  PDDocumentOutline.new

      @doc.document_catalog.document_outline = root_outline

      entries.each do |entry|
        set_outline(root_outline, entry)
      end
    end

    def save(output_pdf_path)
      @doc.save(output_pdf_path)
    end

    def close
      unless @closed
        @doc.close
        @closed = true
      end
    end

    private

    def set_outline(parent_outline, entry)
      page = @pages[entry.fetch('page') - 1]

      dest = PDPageXYZDestination.new
      dest.page = page
      dest.top = page.bbox.upper_right_y
      dest.left = 0
      dest.zoom = -1

      outline = PDOutlineItem.new
      outline.destination = dest
      outline.title = entry.fetch('title')

      entry.fetch('children', []).each do |child|
        set_outline(outline, child)
      end

      parent_outline.add_last(outline)
    end
  end
end
