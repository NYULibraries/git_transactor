class TestQueue < TestDir
  attr_reader :root

  def initialize(path = 'features/fixtures/work')
    @path      = path
    @queue_dir = File.join(@path, 'queue')
    @error_dir = File.join(@path, 'failed')
    @processed_dir = File.join(@path, 'passed')
  end
  def init
    create_root
    [@queue_dir, @error_dir,
     @processed_dir].each {|d| FileUtils.mkdir(d)}
  end
  def enqueue(action, source_path)
    raise ArgumentError.new("invalid action: #{action}") unless
      ['add','rm'].include?(action)
    entry = "#{Time.now.strftime("%Y%m%dT%H%M%S%9N")}.csv"
    entry_path = File.join(@queue_dir, entry)
    File.open(entry_path, "w") do |f|
      f.puts("#{action},#{source_path}")
    end
  end
end
