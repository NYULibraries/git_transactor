class TestRepo
  attr_reader :path

  def initialize(path = 'features/fixtures/repo')
    @path = path
  end

  def nuke
    FileUtils.rm_rf(@path) if File.directory?(@path)
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
