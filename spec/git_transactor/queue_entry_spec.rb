require 'spec_helper'

module GitTransactor
  describe QueueEntry do
    let(:fixture_root) { File.join('spec','fixtures','queue_entries') }
    let(:add_entry)  { File.join(fixture_root, 'add-entry.csv') }
    let(:multi_line_entry)  { File.join(fixture_root, 'multi-line-entry.csv') }
    let(:bad_action_entry)  { File.join(fixture_root, 'bad-action-entry.csv') }
    let(:bad_delimiter_entry) { File.join(fixture_root, 'bad-delimiter-entry.csv') }
    let(:multi_delimiter_entry) { File.join(fixture_root, 'multi-delimiter-entry.csv') }

    context "when class is instantiated" do
      subject { QueueEntry.new(add_entry) }
      it { is_expected.to be_a(GitTransactor::QueueEntry) }
    end

    context "when given a valid entry file" do
      it "should have the correct action" do
        expect(QueueEntry.new(add_entry).action).to be == 'add'
      end
      it "should have the correct path" do
        expect(QueueEntry.new(add_entry).path).to be == '/Users/jgp/tmp/4b3f99d8-a714-4d9c-9109-2ed5fb6d8ab4.txt'
      end
    end

    context "when given a multi-line entry file" do
      it "should raise an ArgumentError" do
        expect{ QueueEntry.new(multi_line_entry) }.to raise_error(ArgumentError)
      end
    end

    context "when given an invalid action entry file" do
      it "should raise an ArgumentError" do
        expect{ QueueEntry.new(bad_action_entry) }.to raise_error(ArgumentError)
      end
    end

    context "when given a multi-delimiter file" do
      it "should have the correct action" do
        expect(QueueEntry.new(multi_delimiter_entry).action).to be == 'add'
      end
      it "should have the correct path" do
        expect(QueueEntry.new(multi_delimiter_entry).path).to be == '/Users/jgp/tmp/4b3f99d8-a714,4d9c-9109-2ed5fb6d8ab4.txt'
      end
    end
  end
end
