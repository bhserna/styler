# frozen_string_literal: true

require_relative "lib/styler/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_styler"
  spec.version       = Styler::VERSION
  spec.authors       = ["Benito Horacio Serna Sandoval"]
  spec.email         = ["bhserna@gmail.com"]
  spec.summary       = "A tool for styling html by composing css utility classes"
  spec.homepage      = "https://github.com/bhserna/styler"
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.require_paths = ["lib"]
  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
end
