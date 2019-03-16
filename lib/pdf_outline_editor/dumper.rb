module PdfOutlineEditor
  class Dumper
    java_import org.apache.pdfbox.pdmodel.PDDocument

    JavaFile = java.io.File

    def initialize(input_pdf_path)
      @input_pdf_path = input_pdf_path
    end

    def dump
      begin
        @doc = PDDocument.load(JavaFile.new(@input_pdf_path))

        @pages = @doc.pages

        root_outline = @doc.document_catalog.document_outline

        if root_outline
          traverse(root_outline)
        else
          nil
        end
      rescue => error
        raise Error, error.message
      ensure
        @doc.close if @doc
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
