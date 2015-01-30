require 'spec_helper'

module GitTransactor
  describe RequestQueue do
    subject(:rq) { RequestQueue.new }
    it { is_expected.to be_a(GitTransactor::RequestQueue) }

    context "with an empty queue" do
#      its(:process) { is_expected.to be_true }
    end
  end
end
