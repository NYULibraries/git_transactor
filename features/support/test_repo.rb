class TestRepo
  attr_reader :rel_path

  def initialize(rel_path = 'tmp/repo')
    @rel_path = rel_path
  end

  def nuke
    FileUtils.rm_rf(@rel_path) if File.directory?(@rel_path)
  end
  def init
    FileUtils.mkdir(@rel_path)
    g = Git.init(@rel_path)
    dummy_file = "#{@rel_path}/foo.txt"
    File.open(dummy_file, 'w') {|f| f.puts(dummy_file)}
    g.add(File.basename(dummy_file))
    g.commit('Initial commit')
  end
end
