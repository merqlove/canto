require_relative 'lib/canto/version'

Gem::Specification.new do |spec|
  spec.name = 'canto'
  spec.version = Canto::VERSION
  spec.authors = ['Alexander Merkulov']
  spec.email = ['merkulov@uchi.ru']

  spec.summary = 'Canto is a tool to run non-blocking ruby programs, like pubsub.'
  spec.description = 'Canto has simple IO.pipe interface, watching for signals, makes your non-blocking running.'
  spec.homepage = 'https://github.com/merqloveu/canto'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/merqloveu/canto'

  spec.files = %w[canto.gemspec README.md CODE_OF_CONDUCT.md LICENSE.txt] + `git ls-files | grep -E '^(bin|lib)'`.split("\n")

  spec.executables = ['canto']
  spec.require_paths = ['lib']
end
