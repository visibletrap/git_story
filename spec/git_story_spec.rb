require_relative '../lib/git_story'

describe GitStory do

  subject { Object.new.extend(GitStory) }

  let(:since) { "941a3e6b34" }
  let(:until_commit) { "13351e6" }

  let(:commits) { %w(8670b5ee48d9ea26a91b22f6eeee2234098b3a08 5257d758a95d37441e65d0b5198cbc9dae8cd2cf 70c9112ddf9f02e6680797f490e418d95a3836ed 13351e6dfc28e05cc4c13ea039654b95c62185a0) }
  let(:stories) { %w(29981485 29521391 29977427 29977409) }
  let(:states) { %w(accepted rejected finished started).each(&:to_sym) }
  let(:project_names) { %w(proj_a proj_b proj_a proj_c) }

  def set_up_parameters
    ENV['TRACKER_TOKEN'] = 'fake tracker token'
  end

  def stub_git
    raw_commit = <<raw_git_commit
#{commits[3]} [##{stories[3]}] Filtered by platform
#{commits[2]} [##{stories[2]}] filter series by genre and country_o
#{commits[1]} [##{stories[1]}] Episode index and Episode show page
#{commits[0]} [##{stories[0]}] Hardcode country filters for music landing page
raw_git_commit
    ManualGitCommitLister.any_instance.stub(:git_list_commit).and_return(raw_commit)
  end

  def stub_network
    TyphoeusTrackerConnector.any_instance.stub(:details_for).with(stories).and_return(Hash[stories.zip(project_names.zip(states))])
  end

  it "run through CommitLister to Renderer" do
    set_up_parameters
    stub_git
    stub_network
    render_input = {}.tap do |h|
      commits.zip(stories).zip(states).zip(project_names).map(&:flatten).each do |cssp|
        h[cssp[0]] = {'story' => cssp[1], 'state' => cssp[2], 'project' => cssp[3]}
      end
    end
    PutsRenderer.any_instance.should_receive(:render).with(render_input)
    subject.state(since, until_commit)
  end

end