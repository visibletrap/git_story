# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_story/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nuttanart Pornprasitsakul"]
  gem.email         = ["visibletrap@gmail.com"]
  #gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{shows status of PivotalTracker's story that git commits belong to}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "git_story"
  gem.require_paths = ["lib"]
  gem.version       = GitStory::VERSION

  gem.add_development_dependency "rspec"
end
