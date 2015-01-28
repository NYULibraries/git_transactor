class TestSourceDir
  attr_reader :rel_path

  def initialize(rel_path = 'tmp/source')
    @rel_path = rel_path
  end

  def nuke
    FileUtils.rm_rf(@rel_path) if File.directory?(@rel_path)
  end
  def init
    FileUtils.mkdir(@rel_path)
  end
  def create_file(fname, msg)
    File.open(File.join(@rel_path, fname), 'w') {|f| f.puts(msg)}
  end
end
