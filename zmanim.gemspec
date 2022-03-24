# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zmanim/version"

Gem::Specification.new do |spec|
  spec.name          = "zmanim"
  spec.version       = Zmanim::VERSION
  spec.authors       = ["Pinny Markowitz"]
  spec.email         = ["pinny@mwitz.com"]

  spec.summary       = %q{A Zmanim library for Ruby}
  spec.description   = %q{Port from Eliyahu Hershfeld's KosherJava project, with some Ruby niceties and other minor modifications.}
  spec.homepage      = "https://github.com/pinnymz/ruby-zmanim"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "tzinfo"
  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "byebug", "~> 9.1"
end
