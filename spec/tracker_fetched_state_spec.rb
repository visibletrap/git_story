require_relative '../lib/tracker_fetched_mapper'

describe TrackerFetchedMapper do

  let(:renderer) { mock('renderer') }
  let(:tracker_connector) { mock('tracker_connector') }

  subject { TrackerFetchedMapper.new(renderer, tracker_connector) }

  it { should respond_to :fetch }

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
      subject.should_receive(:fetch).with(['123', '234']).and_return({ '123' => :accepted, '234' => :rejected })
      subject.map({ '123' => 'x', '234' => 'y' }).should ==
          {
              'x' => { 'story' => '123', 'state' => :accepted },
              'y' => { 'story' => '234', 'state' => :rejected }
          }
    end

    it "ignores commit that corresponding story is not returned from #fetch" do
      subject.should_receive(:fetch).with(['123', '234']).and_return({ '234' => :rejected })
      subject.map({ '123' => 'x', '234' => 'y' }).should ==
          { 'y' => {'story' => '234', 'state' => :rejected } }
    end
  end

end