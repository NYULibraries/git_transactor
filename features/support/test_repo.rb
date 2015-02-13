class TestRepo < TestDir
  attr_reader :path

  def init
    FileUtils.mkdir(@path)
    g = Git.init(@path)
    dummy_file = "#{@path}/foo.txt"
    File.open(dummy_file, 'w') {|f| f.puts(dummy_file)}
    g.add(File.basename(dummy_file))
    g.commit('Initial commit')
  end
end
