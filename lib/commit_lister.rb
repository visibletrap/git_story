require_relative 'state_mapper'

class CommitLister

  def execute(since, until_commit)
    StateMapper.new.execute(list(since, until_commit))
  end

  def list(since, until_commit)
    commit_lines = git_list_commit(since, until_commit).split("\n")
    commits_with_story = commit_lines.reject { |cl| match_story(cl).nil? }
    story_commit = commits_with_story.reverse.map do |cl|
      [match_story(cl)[1], match_commit(cl)[0]]
    end
    Hash[story_commit]
  end

  def match_story(commit_line)
    /\[#(\d*)\]/.match(commit_line)
  end

  def match_commit(commit_line)
    /^\w*/.match(commit_line)
  end

  def git_list_commit(since, until_commit)
    `git log --pretty=oneline #{since}..#{until_commit}`
  end
end