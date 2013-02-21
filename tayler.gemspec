# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tayler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tayler"
  s.version     = Tayler::VERSION
  s.authors     = ["Łukasz Sągol"]
  s.email       = ["lukasz@sagol.pl"]
  s.homepage    = "http://github.com/zgryw/tayler"
  s.summary     = "Soap made easy."
  s.description = "http://stopsoap.com/"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*.rb"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec-rails"
end
