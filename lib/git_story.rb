require_relative 'commit_lister'

class GitStory

  def state(since, until_commit)
    commit_state_factory.list(since, until_commit)
  end

  def commit_state_factory
    renderer = PutsRenderer.new
    state_mapper = StateMapper.new(renderer)
    commit_processor = SplitAndMatchCommitProcessor.new(state_mapper)
    CommitLister.new(commit_processor)
  end
end