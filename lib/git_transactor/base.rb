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
      @num_processed = 0
      @commit_msg   = ''
      queue_entry_files.each do |entry_file|
        process_entry(entry_file)
      end
      @repo.commit(@commit_msg) unless @num_processed == 0
      @num_processed
    end

    private
    def process_entry(entry_file)
        @qe = QueueEntry.new(entry_file)
        case
        when @qe.add? then process_add_entry
        else
          raise ArgumentError.new("unrecognized action: #{@qe.action}")
        end
    end
    def process_add_entry
      setup_paths
      create_repo_subdir_if_needed
      copy_src_file_to_repo
      git_add_file_to_repo
      update_commit_msg_for_add_entry
      relocate_entry_file
      update_num_processed
    end
    def queue_entry_files
      @queue_entry_files ||= Dir.glob(File.join(@work_root, 'queue', '*.csv'))
    end
    def setup_paths
      @file_rel_path = Utils.source_path_to_repo_path(@qe.path)
      @dir_rel_path  = File.dirname(@file_rel_path)
      @file_tgt_path = File.join(@repo_path, @file_rel_path)
    end
    def create_repo_subdir_if_needed
      FileUtils.mkdir(File.join(@repo_path, @dir_rel_path)) unless File.directory?(@dir_rel_path)
    end
    def copy_src_file_to_repo
      FileUtils.cp(@qe.path, @file_tgt_path, preserve: true)
    end
    def git_add_file_to_repo
      @repo.add(@file_rel_path)
    end
    def update_commit_msg_for_add_entry
      @commit_msg += "Updating file #{@file_rel_path}"
    end
    def relocate_entry_file
      FileUtils.mv(@qe.entry_path, File.join(@work_root, 'processed'))
    end
    def update_num_processed
      @num_processed += 1
    end
  end
end
