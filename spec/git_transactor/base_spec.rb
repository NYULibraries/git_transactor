require 'spec_helper'

module GitTransactor
  describe Base do

    let(:repo_path)   { 'spec/fixtures/repo' }
    let(:source_path) { 'spec/fixtures/source' }
    let(:work_root)   { 'spec/fixtures/work' }

    let(:base) { Base.new(repo_path:   repo_path,
                          source_path: source_path,
                          work_root:   work_root) }

    context "when class is instantiated" do
      before(:each) { tr = TestRepo.new(repo_path); tr.nuke; tr.init }
      subject { base }
      it { is_expected.to be_a(GitTransactor::Base) }
    end

    context "with an empty queue" do
      before(:each) do
        tr = TestRepo.new(repo_path);  tr.nuke; tr.init
        tq = TestQueue.new(work_root); tq.nuke; tq.init
      end
      subject { base.process_queue }
      it { should == 0 }
    end

    context "with a single 'add' request in the queue" do
      let(:src_file) { "#{Random.rand 99999}.txt" }
      before(:each) do
        tsd = TestSourceDir.new(source_path)
        tsd.nuke
        tsd.init
        tsd.create_file(src_file, "#{src_file}")
        tq = TestQueue.new(work_root)
        tq.nuke
        tq.init
        tq.enqueue('add', File.expand_path(File.join(tsd.path, src_file)))
      end
      subject { base.process_queue }
      it { should == 1 }
    end
  end
end
