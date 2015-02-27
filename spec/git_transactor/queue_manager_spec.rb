require 'spec_helper'

module GitTransactor
  describe QueueManager do
    let(:existing_root) { 'spec/fixtures/work'}

    describe ".new" do
      context "when class is instantiated with an existing valid root directory" do
        subject { GitTransactor::QueueManager.new(existing_root) }
        it { should be_an_instance_of(GitTransactor::QueueManager) }
      end
      pending "when class is instantiated with a non-existent root directory" do
        context "when parent directory is writable"
        context "when parent directory is unwritabe"
      end
      pending "when instantiated with an invalid root directory" do
        context "when directory is unreadable"
        context "when directory is unwritable"
        context "when root directory exists but does not have a valid structure"
      end
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
