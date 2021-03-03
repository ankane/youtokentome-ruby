require_relative "lib/youtokentome/version"

Gem::Specification.new do |spec|
  spec.name          = "youtokentome"
  spec.version       = YouTokenToMe::VERSION
  spec.summary       = "High performance unsupervised text tokenization for Ruby"
  spec.homepage      = "https://github.com/ankane/youtokentome"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,ext}/**/*", "vendor/YouTokenToMe/{LICENSE,README.md}", "vendor/YouTokenToMe/youtokentome/cpp/**/*"]
  spec.require_path  = "lib"
  spec.extensions    = ["ext/youtokentome/extconf.rb"]

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "rice", ">= 2.2"
end
