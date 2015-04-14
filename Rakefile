require "bundler/gem_tasks"
require_relative "lib/git_transactor"

namespace :git_transactor do

  namespace :setup do
    desc "Initialize queue structure in QUEUE_ROOT directory"
    task :queue do
      GitTransactor::QueueManager.create(ENV["QUEUE_ROOT"])
    end
  end

  desc "Process entries in queue and push to remote"
  task :process_and_push do
    process
    push
  end

  desc "Pull from remote repository to local repository"
  task :pull do
    pull
  end

  desc "Push from local repository to remote repository"
  task :push do
    push
  end

  desc "Pull from remote repository, process queue, and push back to remote repository"
  task :pull_process_push do
    pull
    process
    push
  end

  #----------------------------------------------------------------------------
  # methods

  def gt
    @gt ||= GitTransactor::Processor.new(repo_path:   ENV["LOCAL_REPO"],
                                         source_path: ENV["SOURCE_PATH"],
                                         work_root:   ENV["QUEUE_ROOT"],
                                         remote_url:  ENV["REMOTE_REPO_URL"])
  end

  def process
    gt.process_queue
  end

  def push
    gt.push
  end

  def pull
    gt.pull
  end
end
