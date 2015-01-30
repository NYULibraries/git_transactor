require 'spec_helper'

module GitTransactor
  describe RequestQueue do
    describe ".initialize" do
      subject { RequestQueue.new }
      it { is_expected.to be_a(GitTransactor::RequestQueue) }
    end
    describe "#process" do
    end
  end
end
