class PutsRenderer
  def render(commit_story_state_project)
    commit_story_state_project.each do |commit, ssp|
      unless ssp['state'] == :accepted
        puts "#{commit} ##{ssp['story']} #{ssp['state']} from #{ssp['project']}"
      end
    end
  end
end