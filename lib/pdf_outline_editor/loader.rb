# frozen_string_literal: true

module PdfOutlineEditor
  class Loader
    java_import org.apache.pdfbox.pdmodel.PDDocument
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageXYZDestination
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline
    java_import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem

    JavaFile = java.io.File
    IOException = java.io.IOException

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
      begin
        @doc = PDDocument.load(JavaFile.new(input_pdf_path))
      rescue IOException => e
        raise Error, e.message
      end

      @doc.set_all_security_to_be_removed(true)

      @pages = @doc.pages.to_a

      @closed = false
    end

    def load(entries)
      root_outline = PDDocumentOutline.new

      @doc.document_catalog.document_outline = root_outline

      entries.each do |entry|
        set_outline(root_outline, entry)
      end
    end

    def save(output_pdf_path)
      @doc.save(output_pdf_path)
    end

    def close
      return if @closed

      @doc.close
      @closed = true
    end

    private

    def set_outline(parent_outline, entry)
      page_number = entry.fetch('page')

      max_page_number = @pages.size

      unless (1..max_page_number).include?(page_number)
        raise Error, "page number must be between 1 and #{max_page_number}: got #{page_number}"
      end

      page = @pages[page_number - 1]

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
