class CommitLister

  def list(since, until_commit)
    CommitProcessor.new.execute(git_list_commit(since, until_commit))
  end

  def git_list_commit(since, until_commit)
    `git log --pretty=oneline #{since}..#{until_commit}`
  end

end