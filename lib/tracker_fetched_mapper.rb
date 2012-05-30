class TrackerFetchedMapper

  def initialize(renderer, tracker_connector)
    @renderer = renderer
    @tracker = tracker_connector
  end

  def execute(story_commit)
    @renderer.render(map(story_commit))
  end

  def map(story_commit)
    {}.tap do |h|
      fetch(story_commit.keys).each do |story, state|
        h[story_commit[story]] = {'story' => story, 'state' => state}
      end
    end
  end

  def fetch(stories)
    if ENV['TRACKER_PROJECT_ID']
      projects = ENV['TRACKER_PROJECT_ID'].split(",")
    else
      projects = @tracker.projects
    end
    @tracker.current_state_of(stories, projects)
  end

end