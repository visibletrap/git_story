class CommitLister
  def list(since, until_commit)
    raw_commits = git_list_commit(since, until_commit).split("\n")
    Hash[raw_commits.reverse.map {|c| [/^\w*/.match(c)[0], /\[#(\d*)\]/.match(c)[1]] }]
  end

  def git_list_commit(since, until_commit)
    `git log --pretty=oneline #{since}..#{until_commit}`
  end
end