require_relative 'commit_lister'

class GitStory

  def state(since, until_commit)
    CommitLister.new.list(since, until_commit)
  end
end