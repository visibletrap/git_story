require_relative 'commit_lister'

class GitStory

  def state(since, until_commit)
    CommitLister.new(since, until_commit).execute
  end
end