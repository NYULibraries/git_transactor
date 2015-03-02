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
    let(:valid_create)    { fixture_root + '/valid_create' }
    let(:invalid_create)  { fixture_root + '/invalid_create/work' }
    let(:empty_queue)     { fixture_root + '/empty_queue' }
    let(:populated_queue) { fixture_root + '/populated_queue' }

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
        before(:each) { setup_valid_create }
        it "creates a valid QueueManager structure" do
          expect(GitTransactor::QueueManager.create(valid_create)).to be_an_instance_of(GitTransactor::QueueManager)
        end
      end
      context "when parent directory is unwritabe" do
        it "raises an ArgumentError" do
          expect {GitTransactor::QueueManager.create(invalid_create)}.to raise_error(ArgumentError, /unwritable/)
        end
      end
    end
    describe "#queue" do
      context "when there are no entries" do
        before(:each) { setup_empty_queue }
        subject { GitTransactor::QueueManager.open(empty_queue).queue }
        it { is_expected.to be == [] }
      end

      context "when there are entries" do
        before(:each) { setup_populated_queue }
        it "should have the expected number of entries" do
          expect(GitTransactor::QueueManager.open(populated_queue).queue.length).to be == 2
        end
        it "should return an Array of QueueEntry objects" do
          expect(GitTransactor::QueueManager.open(populated_queue).queue[0]).to be_an_instance_of(QueueEntry)
        end
      end
    end
    describe "#passed" do
      context "when there are no entries" do
        before(:each) { setup_empty_queue }
        subject { GitTransactor::QueueManager.open(empty_queue).passed }
        it { is_expected.to be == [] }
      end

      context "when there are entries" do
        before(:each) { setup_populated_queue }
        it "should have the expected number of entries" do
          expect(GitTransactor::QueueManager.open(populated_queue).passed.length).to be == 3
        end
        it "should return an Array of QueueEntry objects" do
          expect(GitTransactor::QueueManager.open(populated_queue).passed[0]).to be_an_instance_of(QueueEntry)
        end
      end
    end
    describe "#failed" do
      context "when there are no entries" do
        before(:each) { setup_empty_queue }
        subject { GitTransactor::QueueManager.open(empty_queue).failed }
        it { is_expected.to be == [] }
      end
      context "when there are entries" do
        before(:each) { setup_populated_queue }
        it "should have the expected number of entries" do
          expect(GitTransactor::QueueManager.open(populated_queue).failed.length).to be == 1
        end
        it "should return an Array of QueueEntry objects" do
          expect(GitTransactor::QueueManager.open(populated_queue).failed[0]).to be_an_instance_of(QueueEntry)
        end
      end
    end
    describe "#disposition" do
      before(:each) { setup_populated_queue }
      let(:qm) { GitTransactor::QueueManager.open(populated_queue) }
      let(:qe) { qm.queue[0] }
      context "with a failing queue entry" do
        it "should change the entries as expected" do
          expect { qm.disposition(qe, :fail) }.to change { qm.queue.length }.by(-1).and change { qm.failed.length }.by(1)
        end
      end
      describe "with a passing queue entry" do
        it "should change the entries as expected" do
          expect { qm.disposition(qe, :pass) }.to change { qm.queue.length }.by(-1).and change { qm.passed.length }.by(1)
        end
      end
    end
  end
end
