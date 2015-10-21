require 'git'
require 'logger'

module GitTransactor
  ##
  # This class processes GitTransactor queue entries
  class Processor
    include Utils

    def initialize(params)
      logger.level = Logger::INFO
      @params = params
      check_params!
    end

    # returns number of requests processed
    def process_queue
      num_processed = 0
      lock do
        @commit_msg   = ''
        qm.queue.each do |qe|
          result = nil
          begin
            process_entry(qe)
            result = :pass
          rescue StandardError => e
            errors[:process_queue] << e.message
            logger.error("#{qe}:#{e.message}")
            result = :fail
          end
          qm.disposition(qe, result)
          logger.info("#{result}:#{qe}")
          num_processed += 1
        end
        repo.commit(@commit_msg) unless num_processed == 0
      end
      num_processed
    end

    def push
      repo.push(remote_url)
    end

    def pull
      repo.pull
    end

    def errors
      @errors ||= Hash.new { |perrors, key| perrors[key] = [] }
    end

private

    def logger
      @logger ||= Logger.new($stdout)
    end
    # lock queue manager during block execution
    def lock
      qm.lock!
      begin
        yield
      ensure
        qm.unlock
      end
    end

    def check_params!
      [:repo_path, :source_path, :work_root, :remote_url].each do |key|
        errors[key] = "missing #{key}:" if @params[key].nil?
      end
      fail ArgumentError, errors.to_s unless errors.empty?
    end

    def process_entry(qe)
      @qe = qe
      case
      when @qe.add? then process_add_entry
      when @qe.rm?  then process_rm_entry
      else
        fail ArgumentError, "unrecognized action: #{@qe.action}"
      end
    end

    def process_add_entry
      create_repo_subdir_if_needed
      copy_src_file_to_repo
      git_add_file_to_repo
      update_commit_msg_for_add_entry
    end

    def process_rm_entry
      extract_eadid
      git_rm_file_from_repo
      update_commit_msg_for_rm_entry
    end

    def create_repo_subdir_if_needed
      FileUtils.mkdir(dir_tgt_path) unless File.directory?(dir_tgt_path)
    end

    def copy_src_file_to_repo
      FileUtils.cp(@qe.path, file_tgt_path, preserve: true)
    end

    def git_add_file_to_repo
      repo.add(file_rel_path)
    end

    def update_commit_msg_for_add_entry
      @commit_msg += (delimiter + "Updating file #{file_rel_path}")
    end

    def git_rm_file_from_repo
      repo.remove(file_rel_path)
    end

    def update_commit_msg_for_rm_entry
      @commit_msg += (delimiter + "Deleting file #{file_rel_path} EADID='#{eadid}'")
    end

    def delimiter
      @commit_msg.empty? ? '' : ', '
    end

    def repo
      @repo ||= Git.open(repo_path)
    end

    def qm
      @qm ||= QueueManager.open(work_root)
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

    # Return the relative path of the source file in the
    #   Git repository
    #
    # This method converts the absolute path of a source file
    # to the file's path relative path in the repo.
    #
    # for example, if the absolute path of the file you're adding
    # is:
    #         /a/really/cool/path/ead/a/b/c.xml
    #
    # and the repo has the following structure:
    #        <repo root>/a/b/
    #
    # then this method returns
    #         a/b/c.xml
    #
    def file_rel_path
      source_path_to_repo_path(@qe.path)
    end

    def dir_rel_path
      File.dirname(file_rel_path)
    end

    # return the parent directory for the source file in the
    #   Git repository
    #
    def dir_tgt_path
      File.join(repo_path, dir_rel_path)
    end

    # return the path for the source file in the
    #   Git repository
    #
    def file_tgt_path
      File.join(repo_path, file_rel_path)
    end

    def extract_eadid
      @eadid = GitTransactor::EAD.new(file_tgt_path).eadid
    end

    def eadid
      @eadid
    end
  end
end
