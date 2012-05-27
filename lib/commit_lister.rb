require_relative 'state_mapper'

class CommitLister

  def initialize(since = nil, until_commit = nil)
    @since = since
    @until = until_commit
  end

  def execute
    StateMapper.new.execute(list)
  end

  def list
    commit_lines = git_list_commit.split("\n")
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

  def git_list_commit
    `git log --pretty=oneline #{@since}..#{@until}`
  end
end