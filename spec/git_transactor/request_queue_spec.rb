require 'spec_helper'

module GitTransactor
  describe RequestQueue do
    subject(:rq) { RequestQueue.new }
    it { is_expected.to be_a(GitTransactor::RequestQueue) }

    context "with an empty queue" do
      subject { RequestQueue.new.process }
      it { should == 0 }
    end
  end
end
