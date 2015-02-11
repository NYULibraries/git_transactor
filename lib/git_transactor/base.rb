require 'git'

module GitTransactor
  class Base
    def initialize(params)
      @errors = {}
      [:repo_path, :source_path, :work_root].each do |key|
        @errors[key] = "missing #{key}:" if params[key].nil?
      end
      raise ArgumentError.new(@errors.to_s) unless @errors.empty?

      @repo_path   = params[:repo_path]
      @source_path = params[:source_path]
      @work_root   = params[:work_root]

      @repo = Git.open(@repo_path)
    end

    # returns number of requests processed
    def process_queue
      # open queue directory
      # for each request
      #   if add
      #     find file in source directory
      #     copy file from source directory into corresponding repo directory
      #     add the file to the repo
      #     commit the change with the proper commit message
      #
      # error cases:
      #   file specified in add    request not present in source dir
      #   file specified in delete request not present in repo
      #   copy file fails during add
      #   git blows up (git add, git rm, git commit)
      0
    end
  end
end
