# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uncoil/version"

Gem::Specification.new do |s|
  s.name        = "uncoil"
  s.version     = Uncoil::VERSION
  s.authors     = ["Joel Stimson"]
  s.email       = ["contact@cleanroomstudios.com"]
<<<<<<< Updated upstream
  s.homepage    = "https://github.com/stim371/uncoil"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}
=======
  s.homepage    = "http://uncoil.me"
  s.summary     = %q{Uncoil is a gem to unshorten urls so you know where obscured links really go.}
  s.description = %q{Uncoil is a gem to unshorten urls so you know where obscured links really go. If you have bitly login credentials, initialize an instance of Uncoil to use the bitly API.}
>>>>>>> Stashed changes

  s.rubyforge_project = "uncoil"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  
  s.add_runtime_dependency "bitly"
end
