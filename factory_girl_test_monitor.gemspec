# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'factory_girl_test_monitor/version'

Gem::Specification.new do |s|
  s.name        = 'factory_girl_test_monitor'
  s.version     = FactoryGirlTestMonitor::VERSION
  s.authors     = ['Gary S. Weaver']
  s.email       = ['garysweaver@gmail.com']
  s.homepage    = 'https://github.com/garysweaver/factory_girl_test_monitor'
  s.summary     = %q{Help diagnose stack too deep errors related to factory_girl factories in minitest/rspec tests automatically.}
  s.description = %q{Monitors FactoryGirl strategy invocations (e.g. build, create, etc.) per test with ActiveSupport Instrumentation as described in FactoryGirl's getting started doc in order to output the strategy invocations.}
  s.files = Dir['lib/**/*'] + ['README.md']
  s.license = 'MIT'
  s.add_dependency 'activesupport', '>= 3'
  s.add_dependency 'factory_girl'
end
