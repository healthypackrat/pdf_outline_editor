require 'java'

require_relative '../vendor/pdfbox/pdfbox-app-2.0.13.jar'

require 'pdf_outline_editor/dumper'
require 'pdf_outline_editor/loader'
require 'pdf_outline_editor/version'

module PdfOutlineEditor
  class Error < StandardError; end
end
