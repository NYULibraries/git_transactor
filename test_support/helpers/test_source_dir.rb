class TestSourceDir < TestDir
  def init
    FileUtils.mkdir(@path)
  end
end
