# frozen_string_literal: true

require_relative 'lib/solidus_culqi/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_culqi'
  s.version     = SolidusCulqi::VERSION
  s.authors     = ['César Carruitero']
  s.email       = 'ccarruitero@protonmail.com'

  s.summary     = 'Adds solidus support for Culqi Gateway'
  s.description = s.summary
  s.homepage    = 'https://github.com/ccarruitero/solidus_culqi'
  s.license     = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/ccarruitero/solidus_culqi'

  s.required_ruby_version = Gem::Requirement.new('~> 2.6')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|s|features)/})
  s.test_files = files.grep(%r{^(test|s|features)/})
  s.bindir = "exe"
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'culqi-ruby'
  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_support'

  s.add_development_dependency 'solidus_dev_support', '~> 2.5'
end
