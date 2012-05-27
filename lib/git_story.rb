require_relative 'manual_git_commit_lister'
require_relative 'split_and_match_processor'
require_relative 'tracker_fetched_mapper'
require_relative 'puts_renderer'

class GitStory

  def state(since, until_commit)
    commit_state_factory.list(since, until_commit)
  end

  def commit_state_factory
    renderer = PutsRenderer.new
    state_mapper = TrackerFetchedMapper.new(renderer)
    commit_processor = SplitAndMatchProcessor.new(state_mapper)
    ManualGitCommitLister.new(commit_processor)
  end
end