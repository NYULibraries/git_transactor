require 'spec_helper'

module GitTransactor
  describe Base do

    let(:repo_path)   { 'spec/fixtures/repo' }
    let(:source_path) { 'spec/fixtures/source' }
    let(:work_root)   { 'spec/fixtures/work' }

    let(:base) { Base.new(repo_path:   repo_path,
                          source_path: source_path,
                          work_root:   work_root) }


    before(:each) { tr = TestRepo.new(repo_path); tr.nuke; tr.init }

    subject { base }
    it { is_expected.to be_a(GitTransactor::Base) }

    context "with an empty queue" do
      subject { base.process_queue }
      it { should == 0 }
    end
  end
end
