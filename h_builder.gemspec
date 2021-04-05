# frozen_string_literal: true

require_relative "lib/h_builder/version"

Gem::Specification.new do |spec|
  spec.name          = "h_builder"
  spec.version       = HBuilder::VERSION
  spec.authors       = ["Linus Oleander"]
  spec.email         = ["oleander@users.noreply.github.com"]
  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://google.com"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.6.6"

  spec.files = Dir["spec/**/*"]

  spec.add_dependency "dry-core"
  spec.add_dependency "dry-initializer"
  spec.add_dependency "dry-types"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
end
