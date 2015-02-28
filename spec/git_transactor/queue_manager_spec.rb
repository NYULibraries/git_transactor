require 'spec_helper'

module GitTransactor
  describe QueueManager do
    let(:fixture_root)    { 'spec/fixtures/queue_manager' }
    let(:valid_root)      { fixture_root + '/valid_root' }
    let(:unreadable_root) { fixture_root + '/invalid_root/unreadable_root' }
    let(:unwritable_root) { fixture_root + '/invalid_root/unwritable_root' }
    let(:unexecutable_root) { fixture_root + '/invalid_root/unexecutable_root' }
    let(:missing_root)    { fixture_root + '/invalid_root/this/path/does/not/exist' }
    let(:malformed_root)  { fixture_root + '/invalid_root/malformed_root' }
    include Setup::QueueManager

    describe ".open" do
      context "when passed an existing valid root directory" do
        before(:each) { setup_valid_state }
        subject { GitTransactor::QueueManager.open(valid_root) }
        it { should be_an_instance_of(GitTransactor::QueueManager) }
      end
      context "when passed an invalid root directory" do
        context "when directory does not exist" do
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(missing_root)}.to raise_error(ArgumentError, /does not exist/)
          end
        end
        context "when directory is unreadable" do
          before(:each) { setup_unreadable_root }
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(unreadable_root)}.to raise_error(ArgumentError, /unreadable/)
          end
        end
        context "when directory is unwritable" do
          before(:each) { setup_unwritable_root }
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(unwritable_root)}.to raise_error(ArgumentError, /unwritable/)
          end
        end
        context "when directory is unexecutable" do
          before(:each) { setup_unexecutable_root }
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(unexecutable_root)}.to raise_error(ArgumentError, /unexecutable/)
          end
        end
        context "when root directory exists but does not have a valid structure" do
          before(:each) { setup_malformed_root }
          it "raises an ArgumentError" do
            expect {GitTransactor::QueueManager.open(malformed_root)}.to raise_error(ArgumentError)
          end
        end
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
