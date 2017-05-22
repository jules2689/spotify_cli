# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spotify_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "spotify_cli"
  spec.version       = SpotifyCli::VERSION
  spec.authors       = ["Julian Nadeau"]
  spec.email         = ["julian@jnadeau.ca"]
  spec.license       = "MIT"

  spec.summary       = "Spotify Application wrapper for control via command line"
  spec.description   = "Allow control of Spotify using a pretty UI interface. Intentionally simple."
  spec.homepage      = "https://github.com/jules2689/spotify_cli"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ['spotify']
  spec.require_paths = ["lib"]

  spec.add_dependency 'method_source', '~> 0'
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
