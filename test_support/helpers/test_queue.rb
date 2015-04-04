class TestQueue < TestDir
  attr_reader :root

  def initialize(path = 'features/fixtures/work')
    @path       = path
    @queue_dir  = File.join(@path, 'queue')
    @failed_dir = File.join(@path, 'failed')
    @passed_dir = File.join(@path, 'passed')
  end
  def init
    create_root
    [@queue_dir, @failed_dir,
     @passed_dir].each {|d| FileUtils.mkdir(d)}
  end
  def enqueue(action, source_path)
    add_entry(action, source_path, @queue_dir)
  end
  def add_failed(action, source_path)
    add_entry(action, source_path, @failed_dir)
  end
  def add_passed(action, source_path)
    add_entry(action, source_path, @passed_dir)
  end
private
  def add_entry(action, source_path, tgt_path)
    raise ArgumentError.new("invalid action: #{action}") unless
      ['add','rm'].include?(action)
    entry = "#{Time.now.strftime("%Y%m%dT%H%M%S%9N")}.csv"
    entry_path = File.join(tgt_path, entry)
    File.open(entry_path, "w") do |f|
      f.puts("#{action},#{source_path}")
    end
  end
end
