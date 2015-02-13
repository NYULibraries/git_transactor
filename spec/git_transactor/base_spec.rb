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
      it "should return the correct number of entries processed" do
        expect(base.process_queue).to be == 0
      end
    end

    context "with a single 'add' request in the queue" do
      let(:sub_directory) { 'jgp' }
      let(:src_file) { "interesting-stuff.xml" }
      before(:each) do
        tr  = TestRepo.new(repo_path);  tr.nuke; tr.init
        tsd = TestSourceDir.new(source_path)
        tsd.nuke
        tsd.init
        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq = TestQueue.new(work_root)
        tq.nuke
        tq.init
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end
      it "should return the correct number of entries processed" do
        expect(base.process_queue).to be == 1
      end
      it "should move the queue-entry file to the processed directory" do
        base.process_queue
        expect(Dir.glob(File.join(work_root, 'processed','*.csv')).length).to be == 1
      end
    end

    context "with a single 'rm' request in the queue" do
      let(:sub_directory) { 'pgj' }
      let(:file_to_rm) { "spiffingly-interesting.xml" }
      let(:file_to_rm_rel_path) {File.join(sub_directory, file_to_rm)}
      before(:each) do
        tr  = TestRepo.new(repo_path);  tr.nuke; tr.init
        tr.create_sub_directory(sub_directory)
        tr.create_file(file_to_rm_rel_path, "#{file_to_rm}")
        g = Git.open(repo_path)
        g.add(file_to_rm_rel_path)
        g.commit("add test file")
        tq = TestQueue.new(work_root)
        tq.nuke
        tq.init
        tq.enqueue('rm', File.expand_path(File.join(source_path, file_to_rm_rel_path)))
      end
      it "should return the correct number of entries processed" do
        expect(base.process_queue).to be == 1
      end
      it "should move the queue-entry file to the processed directory" do
        base.process_queue
        expect(Dir.glob(File.join(work_root, 'processed','*.csv')).length).to be == 1
      end
    end
  end
end
