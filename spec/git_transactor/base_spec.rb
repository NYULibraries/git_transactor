require 'spec_helper'

module GitTransactor
  describe Base do

    let(:repo_path)   { 'spec/fixtures/repo' }
    let(:source_path) { 'spec/fixtures/source' }
    let(:work_root)   { 'spec/fixtures/work' }
    let(:remote_url)  { 'spec/fixtures/remote_repo/blerf' }

    let(:base) { Base.new(repo_path:   repo_path,
                          source_path: source_path,
                          work_root:   work_root,
                          remote_url:  remote_url) }

    let(:tr) { TestRepo.new(repo_path) }
    let(:tq) { TestQueue.new(work_root) }
    let(:tsd){ TestSourceDir.new(source_path) }

    include SetupUtils

    context "when class is instantiated" do
      subject { base }
      it { is_expected.to be_a(GitTransactor::Base) }
    end


    describe '#process' do
      before(:each) do
        tr.nuke
        tr.init
        tr.create_file('foo.txt','foo.txt')
        tr.add('foo.txt')
        tr.commit('Initial commit')

        tq.nuke
        tq.init

        tsd.nuke
        tsd.init
      end

      context "with an empty queue" do
        it "should return the correct number of entries processed" do
          expect(base.process_queue).to be == 0
        end
      end


      context "with a single 'add' request in the queue" do
        let(:sub_directory) { 'jgp' }
        let(:src_file) { "interesting-stuff.xml" }

        before(:each) do
          setup_add_state
        end

        it "should return the correct number of entries processed" do
          expect(base.process_queue).to be == 1
        end

        it "should move the queue-entry file to the processed directory" do
          base.process_queue
          expect(Dir.glob(File.join(work_root, 'processed','*.csv')).length).to be == 1
        end

        it "should have the correct commit message" do
          base.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Updating file jgp/interesting-stuff.xml'
        end
      end


      context "with a single 'rm' request in the queue" do
        let(:sub_directory) { 'pgj' }
        let(:file_to_rm) { "spiffingly-interesting.xml" }
        let(:file_to_rm_rel_path) {File.join(sub_directory, file_to_rm)}

        before(:each) do
          setup_rm_state
        end

        it "should return the correct number of entries processed" do
          expect(base.process_queue).to be == 1
        end

        it "should move the queue-entry file to the processed directory" do
          base.process_queue
          expect(Dir.glob(File.join(work_root, 'processed','*.csv')).length).to be == 1
        end

        it "should have the correct commit message" do
          base.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Deleting file pgj/spiffingly-interesting.xml'
        end
      end

      context "with two 'add' requests in the queue" do
        let(:sub_directory) { 'jgp' }
        let(:src_file) { "interesting-stuff.xml" }
        let(:sub_directory_2) { 'khq' }
        let(:src_file_2) { "more-interesting-stuff.xml" }
        before(:each) do
          setup_add_state
          setup_add_state_2
        end

        it "should return the correct number of entries processed" do
          expect(base.process_queue).to be == 2
        end

        it "should move the queue-entry file to the processed directory" do
          base.process_queue
          expect(Dir.glob(File.join(work_root, 'processed','*.csv')).length).to be == 2
        end

        it "should have the correct commit message" do
          base.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Updating file jgp/interesting-stuff.xml, Updating file khq/more-interesting-stuff.xml'
        end
      end
    end

    describe "#push" do
      context "under normal conditions" do
        it "should synchronize the repositories" do
          local_repo_path   = 'spec/fixtures/local_repo/blerf'
          local_repo_name   = File.basename(local_repo_path)
          local_repo_parent = File.dirname(local_repo_path)

          base = Base.new(repo_path:   local_repo_path,
                                source_path: source_path,
                                work_root:   work_root,
                                remote_url:  remote_url)

          trr = TestRepo.new(remote_url, bare: true)
          trr.nuke
          trr.init

          td  = TestDir.new(local_repo_parent)
          td.nuke
          td.create_root

          Git.clone(trr.path, local_repo_name, path: td.path)

          local_repo = TestRepo.new(local_repo_path)
          local_repo.open
          local_repo.create_file('unicorns.txt', 'and rainbows!')
          local_repo.add('unicorns.txt')
          local_repo.commit('add unicorns and rainbows!')
          base.push
          puts local_repo_path
          puts trr.path
          local_repo_head  = Git.ls_remote(File.expand_path(local_repo_path))['head'][:sha]
          remote_repo_head = Git.ls_remote(File.expand_path(trr.path))['head'][:sha]
          expect(local_repo_head).to be == remote_repo_head
        end
      end
    end
  end
end
