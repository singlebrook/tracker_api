# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tracker_api/version'

Gem::Specification.new do |spec|
  spec.name        = 'tracker_api'
  spec.version     = TrackerApi::VERSION
  spec.authors     = ['Phil Phillips', 'Forest Carlisle', 'ProductPlan']
  spec.email       = ['irving.phillips@gmail.com']
  spec.summary     = %q{API client for the Pivotal Tracker v5 API}
  spec.description = %q{This gem allows you to easily use the Pivotal Tracker v5 API.}
  spec.homepage    = 'https://github.com/irphilli/tracker_api'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'simplecov'
  # spec.add_development_dependency 'minitest-byebug'

  spec.add_dependency 'addressable'

  spec.add_dependency 'dry-types', '~> 1.7'
  spec.add_dependency 'dry-struct', '~> 1.6'
  spec.add_dependency 'dry-schema', '~> 1.13'

  spec.add_dependency 'faraday', ['>= 2.0', '< 3.0']
  spec.add_dependency 'faraday-multipart'
  spec.add_dependency 'equalizer'
  spec.add_dependency 'representable'
  spec.add_dependency 'mini_mime'
  spec.add_dependency 'json'
end
