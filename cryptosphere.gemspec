# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cryptosphere/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tony Arcieri"]
  gem.email         = ["bascule@gmail.com"]
  gem.description   = "A decentralized globally distributed peer-to-peer data archive"
  gem.summary       = "The Cryptosphere is a P2P cryptosystem for publishing and securely distributing content anonymously with no central point of failure"
  gem.homepage      = "http://github.com/tarcieri/cryptosphere"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "cryptosphere"
  gem.require_paths = ["lib"]
  gem.version       = Cryptosphere::VERSION

  gem.add_runtime_dependency "celluloid"
  gem.add_runtime_dependency "reel"
  gem.add_runtime_dependency "webmachine"
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "rbnacl"
  gem.add_runtime_dependency "base32"
  gem.add_runtime_dependency "activesupport", "~> 4.0.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "benchmark-ips"
  gem.add_development_dependency "webmachine-test"
end
