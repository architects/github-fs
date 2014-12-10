# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github-fs/version.rb'

Gem::Specification.new do |spec|
  spec.name          = "github-fs"
  spec.version       = GHFS::VERSION
  spec.authors       = ["Jonathan Soeder"]
  spec.email         = ["jonathan.soeder@gmail.com"]
  spec.summary       = %q{Work with the Github Contents API the way you would a normal file object}
  spec.description   = %q{Creating, updating, deleting files on the github api using the same APIs as you would working with files your local file system.}
  spec.homepage      = "https://github.com/architects/github-fs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'octokit'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "> 3.0.0"
  spec.add_development_dependency "pry"
end
