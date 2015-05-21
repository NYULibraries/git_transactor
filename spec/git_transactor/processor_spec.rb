require 'spec_helper'

module GitTransactor
  describe Processor do

    let(:repo_path)   { 'spec/fixtures/repo' }
    let(:source_path) { 'spec/fixtures/source' }
    let(:work_root)   { 'spec/fixtures/work' }
    let(:remote_url)  { 'spec/fixtures/remote_repo/blerf' }

    let(:processor) { Processor.new(repo_path:   repo_path,
                                    source_path: source_path,
                                    work_root:   work_root,
                                    remote_url:  remote_url) }

    let(:tr)  { TestRepo.new(repo_path) }
    let(:tq)  { TestQueue.new(work_root) }
    let(:tsd) { TestSourceDir.new(source_path) }

    include Setup::Processor

    context "when class is instantiated" do
      before(:each) { setup_initial_state }
      subject { processor }
      it { is_expected.to be_a(GitTransactor::Processor) }
    end

    describe '#process_queue' do
      before(:each) do
        setup_initial_state
      end

      context "with an empty queue" do
        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 0
        end
      end

      context "with a single 'add' request in the queue" do
        before(:each) do
          setup_add_state
        end

        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 1
        end

        it "should move the queue-entry file to the processed directory" do
          processor.process_queue
          expect(Dir.glob(File.join(work_root, 'passed','*.csv')).length).to be == 1
        end

        it "should have the correct commit message" do
          processor.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Updating file jgp/interesting-stuff.xml'
        end

        it "should have the correct log output" do
          expect {processor.process_queue}.to output(%r{\:add\:.+jgp/interesting-stuff.xml}).to_stdout
        end
      end

      context "with multiple 'add' requests for the same repo subdirectory in the queue" do
        before(:each) do
          setup_add_same_subdir_state
        end

        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 2
        end

        it "should move the queue-entry file to the processed directory" do
          processor.process_queue
          expect(Dir.glob(File.join(work_root, 'passed','*.csv')).length).to be == 2
        end

        it "should have the correct commit message" do
          processor.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Updating file jgp/interesting-stuff.xml, Updating file jgp/super-cool-stuff.xml'
        end
      end

      context "with a single 'rm' request in the queue" do
        before(:each) do
          setup_rm_state
        end

        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 1
        end

        it "should move the queue-entry file to the processed directory" do
          processor.process_queue
          expect(Dir.glob(File.join(work_root, 'passed','*.csv')).length).to be == 1
        end

        it "should have the correct commit message" do
          processor.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Deleting file pgj/spiffingly-interesting.xml'
        end
      end

      context "with two 'rm' requests for the same file in the queue" do
        before(:each) do
          setup_rm_same_file_state
        end

        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 2
        end

        it "should move the queue-entry file to the processed directory" do
          processor.process_queue
          expect(Dir.glob(File.join(work_root, 'passed','*.csv')).length).to be == 1
          expect(Dir.glob(File.join(work_root, 'failed','*.csv')).length).to be == 1
        end

        it "should have the correct commit message" do
          processor.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Deleting file pgj/spiffingly-interesting.xml'
        end
      end

      context "with two 'add' requests in the queue" do
        before(:each) do
          setup_add_state
          setup_add_state_2
        end

        it "should return the correct number of entries processed" do
          expect(processor.process_queue).to be == 2
        end

        it "should move the queue-entry file to the processed directory" do
          processor.process_queue
          expect(Dir.glob(File.join(work_root, 'passed','*.csv')).length).to be == 2
        end

        it "should have the correct commit message" do
          processor.process_queue
          g = Git.open(repo_path)
          expect(g.log[0].message).to be == 'Updating file jgp/interesting-stuff.xml, Updating file khq/more-interesting-stuff.xml'
        end
      end

      context "with a locked queue" do
        before(:each) do
          setup_locked_state
        end

        it "should raise a LockError" do
          expect { processor.process_queue }.to raise_error(LockError)
        end
      end
    end

    describe "#push" do
      context "under normal conditions" do
        let(:local_repo_path)   { 'spec/fixtures/local_repo/blerf' }
        let(:local_repo_name)   { File.basename(local_repo_path)   }
        let(:local_repo_parent) { File.dirname(local_repo_path)    }

        let(:processor) { Processor.new(repo_path:   local_repo_path,
                                        source_path: source_path,
                                        work_root:   work_root,
                                        remote_url:  remote_url) }

        it "should synchronize the repositories" do
          setup_push_state

          processor.push
          local_repo_head  = Git.ls_remote(local_repo_path)['head'][:sha]
          remote_repo_head = Git.ls_remote(remote_url)['head'][:sha]

          expect(local_repo_head).to be == remote_repo_head
        end
      end
    end

    describe "#pull" do
      context "under normal conditions" do
        let(:tmp_repo_path)   { 'spec/fixtures/tmp_repo/blerf' }
        let(:tmp_repo_name)   { File.basename(tmp_repo_path)   }
        let(:tmp_repo_parent) { File.dirname(tmp_repo_path)    }

        let(:local_repo_path)    { 'spec/fixtures/local_repo/blerf' }
        let(:local_repo_name)    { File.basename(local_repo_path)   }
        let(:local_repo_parent)  { File.dirname(local_repo_path)    }

        let(:processor) { Processor.new(repo_path:   local_repo_path,
                                        source_path: source_path,
                                        work_root:   work_root,
                                        remote_url:  remote_url) }

        it "should synchronize the repositories" do
          setup_pull_state

          processor.pull
          local_repo_head  = Git.ls_remote(local_repo_path)['head'][:sha]
          remote_repo_head = Git.ls_remote(remote_url)['head'][:sha]

          expect(local_repo_head).to be == remote_repo_head
        end
      end
    end
  end
end
