require '../lib/state_mapper'
require '../lib/renderer'

describe StateMapper do

  it { should respond_to :fetch }

  describe "#execute" do
    it "calls #map and passes result to Renderer" do
      commit_story = mock('commit_story')
      commit_story_status = mock('commit_story_status')

      subject.should_receive(:map).with(commit_story).and_return(commit_story_status)
      Renderer.any_instance.should_receive(:render).with(commit_story_status)

      subject.execute(commit_story)
    end
  end

  describe '#map' do
    it "maps { commit => story_id } to { commit => { story => story_id, state => state_symbol } }" do
      subject.should_receive(:fetch).with(['123', '234']).and_return({ '123' => :accepted, '234' => :rejected })
      subject.map({ 'x' => '123', 'y' => '234' }).should ==
          {
              'x' => { 'story' => '123', 'state' => :accepted },
              'y' => { 'story' => '234', 'state' => :rejected }
          }
    end

    it "ignores commit that correspond story is not returned from fetch" do
      subject.should_receive(:fetch).with(['123', '234']).and_return({ '234' => :rejected })
      subject.map({ 'x' => '123', 'y' => '234' }).should ==
          { 'y' => {'story' => '234', 'state' => :rejected } }
    end
  end

end