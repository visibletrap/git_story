class TrackerFetchedMapper

  def initialize(renderer, tracker_connector)
    @renderer = renderer
    @tracker = tracker_connector
  end

  def execute(story_commit)
    map = map(story_commit)
    @renderer.render(map)
  end

  def map(story_commit)
    {}.tap do |h|
      @tracker.details_for(story_commit.keys).each do |story, project_state|
        h[story_commit[story]] = {'story' => story, 'state' => project_state[1], 'project' => project_state[0]}
      end
    end
  end
end