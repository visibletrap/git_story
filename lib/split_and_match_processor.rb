class SplitAndMatchProcessor

  def initialize(state_mapper)
    @state_mapper = state_mapper
  end

  def execute(raw_commit)
    @state_mapper.execute(process(raw_commit))
  end

  def process(raw_commit)
    commit_lines = raw_commit.split("\n")
    commits_with_story = reject_no_story(commit_lines)
    story_commit = commits_with_story.reverse.map do |cl|
      [match_story(cl)[1], match_commit(cl)[0]]
    end
    Hash[story_commit]
  end

  def reject_no_story(commit_lines)
    commit_lines.reject { |cl| match_story(cl).nil? }
  end

  def match_story(commit_line)
    /\[#(\d*)\]/.match(commit_line)
  end

  def match_commit(commit_line)
    /^\w*/.match(commit_line)
  end
end