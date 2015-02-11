class TestSourceDir
  attr_reader :path

  def initialize(path = 'features/fixtures/source')
    @path = path
  end

  def nuke
    FileUtils.rm_rf(@path) if File.directory?(@path)
  end
  def init
    FileUtils.mkdir(@path)
  end
  def create_file(fname, msg)
    File.open(File.join(@path, fname), 'w') {|f| f.puts(msg)}
  end
end
