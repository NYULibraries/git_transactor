require 'spec_helper'

module GitTransactor
  describe QueueManager do
    let(:fixture_root)    { 'spec/fixtures/queue_manager' }
    let(:valid_root)      { fixture_root + '/valid_root' }
    let(:unreadable_root) { fixture_root + '/invalid_root/unreadable_root' }

    include Setup::QueueManager

    describe ".open" do
      context "when passed an existing valid root directory" do
        before(:each) { setup_valid_state }
        subject { GitTransactor::QueueManager.open(valid_root) }
        it { should be_an_instance_of(GitTransactor::QueueManager) }
      end
      context "when passed an invalid root directory" do
        before(:each) { setup_unreadable_root }
        context "when directory is unreadable" do
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(unreadable_root)}.to raise_error(ArgumentError, /unreadable/)
          end
        end
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
    describe "#queue" do
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
