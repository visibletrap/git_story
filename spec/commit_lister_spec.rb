require '../lib/commit_lister'

describe CommitLister do

  let(:since) { "941a3e6b34" }
  let(:until_commit) { "13351e6" }

  subject { CommitLister.new(since, until_commit) }

  it { should respond_to(:git_list_commit) }

  describe "#execute" do
    it "lists commit-story and pass to StateMapper" do
      story_commit = mock('commit_story_hash')
      subject.stub(:list).with(since, until_commit).and_return(story_commit)

      StateMapper.any_instance.should_receive(:execute).with(story_commit)

      subject.execute
    end
  end

  describe "#list" do
    it "lists commits from after since_commit to until_commit as a hash { story => commit }" do
      raw_commit = <<raw_git_commit
13351e6dfc28e05cc4c13ea039654b95c62185a0 [#29977409] Filtered by platform
70c9112ddf9f02e6680797f490e418d95a3836ed [#29977427] filter series by genre and country_o
5257d758a95d37441e65d0b5198cbc9dae8cd2cf [#29521391] Episode index and Episode show page
8670b5ee48d9ea26a91b22f6eeee2234098b3a08 [#29981485] Hardcode country filters for music landing page
raw_git_commit
      subject.stub(:git_list_commit).and_return(raw_commit)

      subject.list.should ==
          {
              '29981485' => '8670b5ee48d9ea26a91b22f6eeee2234098b3a08',
              '29521391' => '5257d758a95d37441e65d0b5198cbc9dae8cd2cf',
              '29977427' => '70c9112ddf9f02e6680797f490e418d95a3836ed',
              '29977409' => '13351e6dfc28e05cc4c13ea039654b95c62185a0'
          }
    end

    it "ignores commit without story id" do
      raw_commit = <<raw_git_commit
13351e6dfc28e05cc4c13ea039654b95c62185a0 [#29977409] Filtered by platform
70c9112ddf9f02e6680797f490e418d95a3836ed filter series by genre and country_o
raw_git_commit
      subject.stub(:git_list_commit).and_return(raw_commit)

      subject.list.should ==
          {
              '29977409' => '13351e6dfc28e05cc4c13ea039654b95c62185a0'
          }
    end
  end

end