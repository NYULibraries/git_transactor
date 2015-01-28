class TestSourceDir
  def initialize(path = 'tmp/source')
    @path = path
  end

  def nuke
    FileUtils.rm_rf(@path) if File.exists?(@path)
  end
  def init
    FileUtils.mkdir(@path)
  end
  def create_file(fname, msg)
    File.open(File.join(@path, fname), 'w') {|f| f.puts(msg)}
  end
end
