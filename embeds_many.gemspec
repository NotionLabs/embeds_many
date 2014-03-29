# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "embeds_many/version"

Gem::Specification.new do |s|
  s.name        = "embeds_many"
  s.version     = EmbedsMany::VERSION
  s.authors     = ["liufengyun"]
  s.email       = ["liufengyunchina@gmail.com"]
  s.homepage    = "https://github.com/notionlabs/embeds_many"
  s.summary     = %q{Embed many records based on the power of PostgreSQL's hstore and array}
  s.description = %q{EmbedsMany allows programmers to work with embedded records the same way as activerecord objects}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord','>= 4.0.4')

  s.add_development_dependency('rspec')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('pg')
  s.add_development_dependency('rake')
end
