# `pdf_outline_editor`

[![Build Status](https://travis-ci.org/healthypackrat/pdf_outline_editor.svg?branch=master)](https://travis-ci.org/healthypackrat/pdf_outline_editor)

This gem provides a command to get/set PDF outlines from a JSON/YAML definition file.

## Requirements

- JRuby

## Installation

```
$ jgem install pdf_outline_editor
```

## Usage

First, generate outlines definition file by running `init` command:

```
$ pdf_outline_editor init -f json > toc.json
```

or, by running `dump` command with an existing pdf file:

```
$ pdf_outline_editor dump -f json input.pdf > toc.json
```

(Edit `toc.json` as you like...)

Then run `load` command to set outlines:

```
$ pdf_outline_editor load input.pdf toc.json output.pdf
```

## Development

Run `bin/jruby-ng-server` in a new terminal window for faster loading.

Then run `bin/rspec` to run the specs.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/healthypackrat/pdf_outline_editor>.

## License

The gem is available as open source under the terms of the [Apache License, Version 2.0](https://opensource.org/licenses/Apache-2.0).
