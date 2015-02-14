class TestDir
  attr_reader :path

  def initialize(path = 'features/fixtures/source')
    @path = path
  end

  def nuke
    FileUtils.rm_rf(@path) if File.directory?(@path)
  end
  def create_file(fname, msg)
    File.open(File.join(@path, fname), 'w') {|f| f.puts(msg)}
  end
  def create_sub_directory(rel_path)
    FileUtils.mkdir_p(File.join(@path, rel_path))
  end
end