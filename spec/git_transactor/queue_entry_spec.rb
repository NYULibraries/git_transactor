require 'spec_helper'

module GitTransactor
  describe QueueEntry do
    let(:fixture_root) { File.join('spec','fixtures','queue_entries') }
    let(:valid_entry)  { File.join(fixture_root, 'valid-entry.csv') }
    let(:multi_line_entry)  { File.join(fixture_root, 'multi-line-entry.csv') }
    let(:bad_action_entry)  { File.join(fixture_root, 'bad-action-entry.csv') }

    context "when class is instantiated" do
      subject { QueueEntry.new(valid_entry) }
      it { is_expected.to be_a(GitTransactor::QueueEntry) }
    end

    context "when given a multi-line entry file" do
      it "should raise an ArgumentError" do
        expect{ QueueEntry.new(multi_line_entry) }.to raise_error(ArgumentError)
      end
    end

    context "when given a invalid action entry file" do
      it "should raise an ArgumentError" do
        expect{ QueueEntry.new(bad_action_entry) }.to raise_error(ArgumentError)
      end
    end
  end
end
