# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_transactor/version'

Gem::Specification.new do |spec|
  spec.name          = "git_transactor"
  spec.version       = GitTransactor::VERSION
  spec.authors       = ["jgpawletko"]
  spec.email         = ["jgpawletko@gmail.com"]
  spec.summary       = %q{Enqueue and process changes to a git repo.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/jgpawletko/git_transactor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "git", "~> 1.2.9"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "cucumber", "~> 1.3.18"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
