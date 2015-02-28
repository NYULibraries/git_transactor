module GitTransactor
  class QueueManager
    def self.open(root)
      self.new(root)
    end
    def self.create(root)
      self.create_structure(root)
      self.new(root)
    end
    private
    def self.create_structure(root)
      [root,
       root + '/queue',
       root + '/processed',
       root + '/error'].each {|d| Dir.mkdir(d)}
    end
    def initialize(root)
      @root = root
      @errors = {}
      check_structure
    end
    def check_structure
      check_root_dir
      check_queue_dir
      check_processed_dir
      check_error_dir
      raise ArgumentError.new(@errors) unless @errors.empty?
    end
    def check_root_dir
      errors = check_dir(@root)
      add_error(@root, errors.join(',')) unless errors.empty?
    end
    def check_queue_dir
      errors = check_dir(queue_path)
      add_error(queue_path, errors.join(',')) unless errors.empty?
    end
    def check_processed_dir
      errors = check_dir(processed_path)
      add_error(processed_path, errors.join(',')) unless errors.empty?
    end
    def check_error_dir
      errors = check_dir(error_path)
      add_error(error_path, errors.join(',')) unless errors.empty?
    end
    def check_dir(path)
      errors = [ ]
      errors << 'does not exist' unless File.directory?(path)
      errors << 'unreadable'     unless File.readable?(path)
      errors << 'unwritable'     unless File.writable?(path)
      errors << 'unexecutable'   unless File.executable?(path)
      errors
    end
    def queue_path
      @queue_path || File.join(@root, 'queue')
    end
    def processed_path
      @processed_path || File.join(@root, 'processed')
    end
    def error_path
      @error_path || File.join(@root, 'error')
    end
    def add_error(key, message)
      @errors[key] = message
    end
  end
end
