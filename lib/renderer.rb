class Renderer
  def render(commit_story_state)
    commit_story_state.each do |commit, story_state|
      unless story_state['state'] == :accepted
        puts "#{commit} ##{story_state['story']} #{story_state['state']}"
      end
    end
  end
end