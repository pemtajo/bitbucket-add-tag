describe Fastlane::Actions::BitbucketAddTagAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The bitbucket_add_tag plugin is working!")

      Fastlane::Actions::BitbucketAddTagAction.run(nil)
    end
  end
end
