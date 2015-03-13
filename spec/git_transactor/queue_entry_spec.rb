require 'spec_helper'

module GitTransactor
  describe QueueEntry do
    let(:fixture_root) { File.join('spec','fixtures','queue_entries') }
    let(:add_entry)    { File.join(fixture_root, 'add-entry.csv') }
    let(:rm_entry)     { File.join(fixture_root, 'rm-entry.csv') }
    let(:multi_line_entry)  { File.join(fixture_root, 'multi-line-entry.csv') }
    let(:bad_action_entry)  { File.join(fixture_root, 'bad-action-entry.csv') }
    let(:bad_delimiter_entry) { File.join(fixture_root, 'bad-delimiter-entry.csv') }
    let(:multi_delimiter_entry) { File.join(fixture_root, 'multi-delimiter-entry.csv') }


    describe "class constant" do
      it "should have the expected value" do
        expect(GitTransactor::QueueEntry::FILE_GLOB).to be == '*.csv'
      end
    end

    describe ".new" do
      context "when class is instantiated" do
        subject(:qe) { QueueEntry.new(add_entry) }
        it { is_expected.to be_a(GitTransactor::QueueEntry) }

        it "should have the correct action" do
          expect(qe).to be_add
        end
        it "should have the correct path" do
          expect(qe.path).to be == '/Users/jgp/tmp/4b3f99d8-a714-4d9c-9109-2ed5fb6d8ab4.txt'
        end
        it "should have the correct entry_path" do
          expect(qe.entry_path).to be == add_entry
        end
        it "should have the correct entry_name" do
          expect(qe.entry_name).to be == File.basename(add_entry)
        end
      end

      context "when instantiated with a multi-line entry file" do
        it "should raise an ArgumentError" do
          expect{ QueueEntry.new(multi_line_entry) }.to raise_error(ArgumentError)
        end
      end

      context "when instantiated with an invalid action entry file" do
        it "should raise an ArgumentError" do
          expect{ QueueEntry.new(bad_action_entry) }.to raise_error(ArgumentError)
        end
      end

      context "when instantiated with a multi-delimiter file" do
        it "should have the correct action" do
          expect(QueueEntry.new(multi_delimiter_entry).action).to be == 'add'
        end
        it "should have the correct path" do
          expect(QueueEntry.new(multi_delimiter_entry).path).to be == '/Users/jgp/tmp/4b3f99d8-a714,4d9c-9109-2ed5fb6d8ab4.txt'
        end
      end
    end

    describe "#add?" do
      context "when instantiated with a valid add-entry file" do
        subject(:qe) { QueueEntry.new(add_entry) }
        it "should be true" do
          expect(qe).to be_add
        end
      end
      context "when instantiated with a valid rm-entry file" do
        subject(:qe) { QueueEntry.new(rm_entry) }
        it "should be false" do
          expect(qe).not_to be_add
        end
      end
    end

    describe "#rm?" do
      context "when instantiated with a valid rm-entry file" do
        subject(:qe) { QueueEntry.new(rm_entry) }
        it "should be true" do
          expect(qe).to be_rm
        end
      end
      context "when instantiated with a valid add-entry file" do
        subject(:qe) { QueueEntry.new(add_entry) }
        it "should be false" do
          expect(qe).not_to be_rm
        end
      end
    end
  end
end
