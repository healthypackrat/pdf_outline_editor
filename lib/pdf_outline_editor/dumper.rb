module PdfOutlineEditor
  class Dumper
    java_import org.apache.pdfbox.pdmodel.PDDocument

    JavaFile = java.io.File

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
      rescue
        raise Error, $!.message
      end

      @pages = @doc.pages

      @closed = false
    end

    def dump
      root_outline = @doc.document_catalog.document_outline

      if root_outline
        traverse(root_outline)
      else
        nil
      end
    end

    def close
      unless @closed
        @doc.close
        @closed = true
      end
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
