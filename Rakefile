require "bundler/gem_tasks"
require_relative "lib/git_transactor"


namespace :git_transactor do
  namespace :setup do
    desc "Initialize queue structure in QUEUE_ROOT directory"
    task :queue do
      GitTransactor::QueueManager.create(ENV["QUEUE_ROOT"])
    end
  end
end
