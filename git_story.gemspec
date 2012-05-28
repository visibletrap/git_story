# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_story/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nuttanart Pornprasitsakul"]
  gem.email         = ["visibletrap@gmail.com"]
  gem.description   = %q{
    This gem help you check which commits in your git repository belonges to unaccepted PivotalTracker's story
    so that you can make a decision whether you should deploy those commits or not.
  }
  gem.summary       = %q{shows unaccepted status of PivotalTracker's story that git commits belong to}
  gem.homepage      = "http://github.com/visibletrap/git_story"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "git_story"
  gem.require_paths = ["lib"]
  gem.version       = GitStory::VERSION

  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency 'nokogiri', '~> 1.5'
  gem.add_runtime_dependency 'typhoeus', '~> 0.3'
end
