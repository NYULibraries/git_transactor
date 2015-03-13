require 'git'

module GitTransactor
  class Processor
    def initialize(params)
      @params = params
      check_params!

      @repo        = Git.open(repo_path)
    end

    # returns number of requests processed
    def process_queue
      num_processed = 0
      @commit_msg   = ''
      qm.queue.each do |qe|
        result = nil
        begin
          process_entry(qe)
          result = :pass
        rescue Exception => e
          errors << e.message
          result = :fail
        end
        qm.disposition(qe, result)
        num_processed += 1
      end
      @repo.commit(@commit_msg) unless num_processed == 0
      num_processed
    end

    def push
      @repo.push(remote_url)
    end

private
    def check_params!
      [:repo_path, :source_path, :work_root, :remote_url].each do |key|
        errors[key] = "missing #{key}:" if @params[key].nil?
      end
      raise ArgumentError.new(errors.to_s) unless errors.empty?
    end

    def process_entry(qe)
      @qe = qe
      case
      when @qe.add? then process_add_entry
      when @qe.rm?  then process_rm_entry
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
    end

    def process_rm_entry
      setup_paths
      git_rm_file_from_repo
      update_commit_msg_for_rm_entry
    end

    def setup_paths
      @dir_rel_path  = File.dirname(file_rel_path)
      @dir_tgt_path  = File.join(repo_path, @dir_rel_path)
      @file_tgt_path = File.join(repo_path, file_rel_path)
    end

    def create_repo_subdir_if_needed
      FileUtils.mkdir(@dir_tgt_path) unless File.directory?(@dir_tgt_path)
    end

    def copy_src_file_to_repo
      FileUtils.cp(@qe.path, @file_tgt_path, preserve: true)
    end

    def git_add_file_to_repo
      @repo.add(file_rel_path)
    end

    def update_commit_msg_for_add_entry
      @commit_msg += (delimiter + "Updating file #{file_rel_path}")
    end

    def git_rm_file_from_repo
      @repo.remove(file_rel_path)
    end

    def update_commit_msg_for_rm_entry
      @commit_msg += (delimiter + "Deleting file #{file_rel_path}")
    end

    def delimiter
      @commit_msg.empty? ? '' : ', '
    end

    def qm
      @qm ||= QueueManager.open(work_root)
    end

    def errors
      @errors ||= {}
    end

    def repo_path
      @params[:repo_path]
    end

    def work_root
      @params[:work_root]
    end

    def remote_url
      @params[:remote_url]
    end

    # Return the relative path of the file in the repository
    #
    # This performs a conversion between the absolute path of a file
    # to be added or removed to the file's path relative path
    # in the repo.
    #
    # for example, if your repo is structured as:
    #   <repo root>/a/b/c.xml
    # and the absolute path of your file is:
    #  /a/really/cool/path/ead/a/b/c.xml
    # this method performs the conversion
    def file_rel_path
      Utils.source_path_to_repo_path(@qe.path)
    end
  end
end
