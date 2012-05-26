class StateMapper

  def execute(commit_story)

  end

  def map(commit_story)
    story_state = fetch(commit_story.values)
    commit_story.tap do |cs|
      cs.each do |commit, story|
        cs[commit] = { 'story' => story, 'state' => story_state[story] }
      end
    end
  end

  def fetch

  end

end