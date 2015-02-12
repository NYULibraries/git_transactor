class TestQueue
  attr_reader :root

  def initialize(path = 'features/fixtures/work')
    @path      = path
    @queue_dir = File.join(@path, 'queue')
    @error_dir = File.join(@path, 'error')
    @processed_dir = File.join(@path, 'processed')
  end
  def nuke
    FileUtils.rm_rf(@path) if File.directory?(@path)
  end
  def init
    [@path, @queue_dir, @error_dir,
     @processed_dir].each {|d| FileUtils.mkdir(d)}
  end
  def enqueue(action, source_path)
    raise ArgumentError.new("invalid action: #{action}") unless
      ['add','rm'].include?(action)
    entry = "#{Time.now.strftime("%Y%m%dT%H%M%S")}.csv"
    entry_path = File.join(@queue_dir, entry)
    File.open(entry_path, "w") do |f|
      f.puts("#{action},#{source_path}")
    end
  end
end