$:.push File.expand_path('../lib', __FILE__)

require 'solidus_culqi/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_culqi'
  s.version     = SolidusCulqi::VERSION
  s.summary     = 'Adds solidus support for Culqi Gateway'
  s.description = s.summary
  s.license     = 'MIT'

  s.author      = 'César Carruitero'
  s.email       = 'ccarruitero@protonmail.com'
  s.homepage    = 'https://github.com/ccarruitero/solidus_culqi'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency 'culqi-ruby'
  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_support'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
