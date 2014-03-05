# -*- encoding: utf-8 -*-
require File.expand_path("../lib/avetmiss_data/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "avetmiss_data"
  s.version     = AvetmissData::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Brenton "B-Train" Fletcher, Jehanzeb Khan']
  s.email       = []
  s.homepage    = "http://github.com/jobready/avetmiss_data"
  s.summary     = ""
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "avetmiss_data"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.14.1"
  s.add_development_dependency "factory_girl", ">= 4.4.0"
  s.add_development_dependency "cane"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
