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
    gt = GitTransactor::Processor.new(repo_path:   ENV["LOCAL_REPO"],
                                      source_path: ENV["SOURCE_PATH"],
                                      work_root:   ENV["QUEUE_ROOT"],
                                      remote_url:  ENV["REMOTE_REPO_URL"])
    gt.process_queue
    gt.push
  end
end
