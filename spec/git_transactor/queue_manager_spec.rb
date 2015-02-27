require 'spec_helper'

module GitTransactor
  describe QueueManager do
    let(:valid_root) { 'spec/fixtures/queue_manager/valid_root'}

    include Setup::QueueManager

    describe ".open" do
      context "when passed an existing valid root directory" do
        before(:each) { setup_valid_state }
        subject { GitTransactor::QueueManager.open(valid_root) }
        it { should be_an_instance_of(GitTransactor::QueueManager) }
      end
      pending "when passed an invalid root directory" do
        context "when directory is unreadable"
        context "when directory is unwritable"
        context "when root directory exists but does not have a valid structure"
      end
    end
    describe ".create" do
      context "when parent directory is writable" do
        pending "creates the expected directory structure"
      end
      context "when parent directory is unwritabe"
    end
    describe "#incoming" do
      pending "when there are no entries"
      pending "when there are entries"
    end
    describe "#passed" do
      pending "when there are no entries"
      pending "when there are entries"
    end
    describe "#failed" do
      pending "when there are no entries"
      pending "when there are entries"
    end
    describe "#disposition" do
      pending "with a failing queue entry"
      pending "with a passing queue entry"
    end
  end
end
