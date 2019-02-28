lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pdf_outline_editor/version"

Gem::Specification.new do |spec|
  spec.name          = "pdf_outline_editor"
  spec.version       = PdfOutlineEditor::VERSION
  spec.platform      = 'java'
  spec.authors       = ["healthypackrat"]
  spec.email         = ["healthypackrat@gmail.com"]

  spec.summary       = "Set PDF outlines from a JSON or YAML config file"
  spec.homepage      = "https://github.com/healthypackrat/pdf_outline_editor"
  spec.license       = "Apache-2.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
