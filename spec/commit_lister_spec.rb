require '../lib/commit_processor'

describe CommitProcessor do

  describe "#execute" do
    it "process raw commit and pass to StateMapper" do
      raw_commit = 'raw_commit'
      story_commit = mock('story_commit_hash')
      subject.stub(:process).with(raw_commit).and_return(story_commit)

      StateMapper.any_instance.should_receive(:execute).with(story_commit)

      subject.execute(raw_commit)
    end
  end

  describe "#process" do
    it "processes raw_commit string to a hash { story => commit }" do
      raw_commit = <<raw_git_commit
13351e6dfc28e05cc4c13ea039654b95c62185a0 [#29977409] Filtered by platform
70c9112ddf9f02e6680797f490e418d95a3836ed [#29977427] filter series by genre and country_o
5257d758a95d37441e65d0b5198cbc9dae8cd2cf [#29521391] Episode index and Episode show page
8670b5ee48d9ea26a91b22f6eeee2234098b3a08 [#29981485] Hardcode country filters for music landing page
raw_git_commit

      subject.process(raw_commit).should ==
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

      subject.process(raw_commit).should ==
          {
              '29977409' => '13351e6dfc28e05cc4c13ea039654b95c62185a0'
          }
    end
  end

end