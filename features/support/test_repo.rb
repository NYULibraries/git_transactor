class TestRepo
  def initialize(path = 'tmp/repo')
    @path = path
  end

  def nuke
    FileUtils.rm_rf(@path) if File.exists?(@path)
  end
  def init
    FileUtils.mkdir(@path)
    g = Git.init(@path)
    dummy_file = "#{@path}/foo.txt"
    File.open(dummy_file, 'w') {|f| f.puts(dummy_file)}
    g.add(File.basename(dummy_file))
    g.commit('Initial commit')
  end
end
