require 'java'

require_relative '../vendor/pdfbox/pdfbox-app-2.0.13.jar'

require 'pdf_outline_editor/version'

require 'pdf_outline_editor/dumper'
require 'pdf_outline_editor/loader'

require 'pdf_outline_editor/runner'
require 'pdf_outline_editor/commands/dump_command'
require 'pdf_outline_editor/commands/init_command'
require 'pdf_outline_editor/commands/load_command'

module PdfOutlineEditor
  class Error < StandardError; end
end
