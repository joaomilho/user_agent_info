# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "user_agent_info/version"

Gem::Specification.new do |s|
  s.name        = "user_agent_info"
  s.version     = UserAgentInfo::VERSION
  s.authors     = ["Juan Maiz"]
  s.email       = ["juanmaiz@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "user_agent_info"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
