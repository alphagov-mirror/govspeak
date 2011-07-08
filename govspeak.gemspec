# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "govspeak"
  s.version       = "0.8.3"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Ben Griffiths"]
  s.email         = ["ben@alphagov.co.uk"]
  s.homepage      = "http://github.com/alphagov/govspeak"
  s.summary       = %q{Markup language for single domain}
  s.description   = %q{Markup language for single domain}

  s.files         = Dir[
    'lib/**/*',
    'README.md',
    'Gemfile',
    'Rakefile'
  ]
  s.test_files    = Dir['test/**/*']
  s.require_paths = ["lib"]

  s.add_dependency 'kramdown', '~> 0.13.3'
  
  s.add_development_dependency 'rake', '~> 0.8.0'
  
end