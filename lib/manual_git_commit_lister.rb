class ManualGitCommitLister

  def initialize(commit_processor)
    @commit_processor = commit_processor
  end

  def list(since, until_commit)
    @commit_processor.execute(git_list_commit(since, until_commit))
  end

  def git_list_commit(since, until_commit)
    `git log --pretty=oneline #{since}..#{until_commit}`
  end

end