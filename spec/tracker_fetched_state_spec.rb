require_relative '../lib/tracker_fetched_mapper'

describe TrackerFetchedMapper do

  let(:renderer) { mock('renderer') }
  let(:tracker_connector) { mock('tracker_connector') }

  subject { TrackerFetchedMapper.new(renderer, tracker_connector) }

  describe "#execute" do
    it "calls #map and passes result to Renderer" do
      commit_story = mock('commit_story')
      commit_story_status = mock('commit_story_status')

      subject.should_receive(:map).with(commit_story).and_return(commit_story_status)
      renderer.should_receive(:render).with(commit_story_status)

      subject.execute(commit_story)
    end
  end

  describe '#map' do
    it "maps { story_id => commit } to { commit => { story => story_id, state => state_symbol } }" do
      tracker_connector.stub(:details_for).with(['123', '234']).and_return({ '123' => ['proj_a', :accepted], '234' => ['proj_b', :rejected] })
      subject.map({ '123' => 'x', '234' => 'y' }).should ==
          {
              'x' => { 'story' => '123', 'state' => :accepted, 'project' => 'proj_a' },
              'y' => { 'story' => '234', 'state' => :rejected, 'project' => 'proj_b' }
          }
    end

    it "ignores commit that corresponding story is not returned from #fetch" do
      tracker_connector.should_receive(:details_for).with(['123', '234']).and_return({ '234' => ['proj_b', :rejected] })
      subject.map({ '123' => 'x', '234' => 'y' }).should ==
          { 'y' => {'story' => '234', 'state' => :rejected, 'project' => 'proj_b' } }
    end
  end

end