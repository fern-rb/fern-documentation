lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fern/documentation/version'

Gem::Specification.new do |s|
  s.name        = 'fern-documentation'
  s.version     = Fern::Documentation::VERSION
  s.date        = '2018-02-13'
  s.authors     = ['Kyle Kestell']
  s.email       = 'kyle@kestell.org'
  s.summary     = 'Fern Documentation'
  s.description = 'Automatically generate documentation for Fern APIs.'
  s.homepage    = 'https://github.com/fern-fb/fern-documentation'
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*']

  s.required_ruby_version = '>= 2.3.0'

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake', '~> 10.0'

  s.add_runtime_dependency 'actionpack', '~> 5.0'
  s.add_runtime_dependency 'activesupport', '~> 5.0'
  s.add_runtime_dependency 'mustache', '~> 1.0'
end
