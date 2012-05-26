class CommitLister
  def list(since, until_commit)
    commits = git_list_commit(since, until_commit).split("\n")
    commits_with_story = commits.reject { |c| /\[#(\d*)\]/.match(c).nil? }
    commit_story = commits_with_story.reverse.map do |c|
      [/^\w*/.match(c)[0], /\[#(\d*)\]/.match(c)[1]]
    end
    Hash[commit_story]
  end

  def git_list_commit(since, until_commit)
    `git log --pretty=oneline #{since}..#{until_commit}`
  end
end