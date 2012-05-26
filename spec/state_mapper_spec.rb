require '../lib/state_mapper'

describe StateMapper do

  it { should respond_to :fetch }

  describe "#execute" do
    it "maps commit_story to commit_story_status"
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
  end

end