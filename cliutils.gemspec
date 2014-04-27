# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cliutils/constants'

Gem::Specification.new do |spec|
  spec.name             = "cliutils"
  spec.version          = CLIUtils::VERSION
  spec.authors          = ["Aaron Bach"]
  spec.email            = ["bachya1208@googlemail.com"]
  spec.summary          = CLIUtils::SUMMARY
  spec.description      = CLIUtils::DESCRIPTION
  spec.homepage         = "https://github.com/bachya/cliutils"
  spec.license          = "MIT"

  spec.files            = `git ls-files -z`.split("\x0")
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  spec.add_development_dependency('bundler', '~> 1.5')
  spec.add_development_dependency('coveralls', '0.7.0')
  spec.add_development_dependency('rake', '~> 0')
  spec.add_development_dependency('yard', '0.8.7.4')
  spec.add_runtime_dependency('launchy', '2.4.2')
end
