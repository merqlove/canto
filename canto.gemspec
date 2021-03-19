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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
