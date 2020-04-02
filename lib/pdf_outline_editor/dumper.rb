# frozen_string_literal: true

module PdfOutlineEditor
  class Dumper
    java_import org.apache.pdfbox.pdmodel.PDDocument

    JavaFile = java.io.File
    IOException = java.io.IOException

    def self.open(input_pdf_path)
      dumper = new(input_pdf_path)

      begin
        yield dumper
      ensure
        dumper.close
      end
    end

    attr_reader :closed

    def initialize(input_pdf_path)
      begin
        @doc = PDDocument.load(JavaFile.new(input_pdf_path))
      rescue IOException => e
        raise Error, e.message
      end

      @pages = @doc.pages

      @closed = false
    end

    def dump
      root_outline = @doc.document_catalog.document_outline

      return unless root_outline

      traverse(root_outline)
    end

    def close
      return if @closed

      @doc.close
      @closed = true
    end

    private

    def traverse(outline)
      outline_items = []

      current = outline.first_child

      while current
        outline_item = {}

        outline_item['title'] = current.title

        page = current.find_destination_page(@doc)
        outline_item['page'] = @pages.index_of(page) + 1

        children = traverse(current)
        outline_item['children'] = children unless children.empty?

        outline_items << outline_item

        current = current.next_sibling
      end

      outline_items
    end
  end
end
