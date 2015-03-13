require 'fileutils'

module GitTransactor
  class QueueManager
    def self.open(root)
      self.new(root)
    end
    def self.create(root)
      self.create_structure(root)
      self.new(root)
    end
    def queue
      entries(:queue_entry_files)
    end
    def passed
      entries(:passed_entry_files)
    end
    def failed
      entries(:failed_entry_files)
    end
    def disposition(qe, result)
      valid_results = [ :pass, :fail ]
      raise ArgumentError.new("must be a QueueEntry") unless qe.is_a?(QueueEntry)
      raise ArgumentError.new("must be in #{valid_results}") unless valid_results.include?(result)
      mv_entry(qe, result)
    end

private
    QUEUE_SUBDIR  = 'queue'
    PASSED_SUBDIR = 'passed'
    FAILED_SUBDIR = 'failed'

    def self.create_structure(root)
      parent = File.dirname(File.expand_path(root))
      raise ArgumentError.new("#{parent} unwritable") unless File.writable?(parent)
      [root,
       File.join(root, QUEUE_SUBDIR),
       File.join(root, PASSED_SUBDIR),
       File.join(root, FAILED_SUBDIR)].each {|d| Dir.mkdir(d) unless File.directory?(d) }
    end

    def initialize(root)
      @root = root
      check_structure
    end

    def check_structure
      check_root_dir
      check_queue_dir
      check_passed_dir
      check_failed_dir
      raise ArgumentError.new(errors) unless errors.empty?
    end

    def check_root_dir
      errors = check_dir(@root)
      add_error(@root, errors.join(',')) unless errors.empty?
    end

    def check_queue_dir
      errors = check_dir(queue_path)
      add_error(queue_path, errors.join(',')) unless errors.empty?
    end

    def check_passed_dir
      errors = check_dir(passed_path)
      add_error(passed_path, errors.join(',')) unless errors.empty?
    end

    def check_failed_dir
      errors = check_dir(failed_path)
      add_error(failed_path, errors.join(',')) unless errors.empty?
    end

    def check_dir(path)
      l_errors = [ ]
      l_errors << 'does not exist' unless File.directory?(path)
      l_errors << 'unreadable'     unless File.readable?(path)
      l_errors << 'unwritable'     unless File.writable?(path)
      l_errors << 'unexecutable'   unless File.executable?(path)
      l_errors
    end

    def queue_path
      @queue_path ||= File.join(@root, QUEUE_SUBDIR)
    end

    def passed_path
      @passed_path ||= File.join(@root, PASSED_SUBDIR)
    end

    def failed_path
      @failed_path ||= File.join(@root, FAILED_SUBDIR)
    end

    def add_error(key, message)
      errors[key] = message
    end

    def queue_entry_files
      entry_files(queue_path)
    end

    def passed_entry_files
      entry_files(passed_path)
    end

    def failed_entry_files
      entry_files(failed_path)
    end

    def mv_entry(qe, result)
      tgtdir = case result
               when :fail then failed_path
               when :pass then passed_path
               else raise "Internal Error: invalid result: #{result}"
               end

      FileUtils.mv(qe.entry_path, tgtdir)
    end
    def errors
      @errors ||= {}
    end
    def entry_files(path)
      Dir.glob(File.join(path, '*.csv')).sort
    end
    def entries(method)
      self.send(method).collect { |qef| QueueEntry.new(qef) }
    end
  end
end
