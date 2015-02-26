require 'forwardable'

class TestRepo < TestDir
  attr_reader :path

  extend Forwardable
  def_delegators :@g, :add, :commit, :status

  def init
    create_root
    @g = Git.init(@path, @options)
  end

  def open
    @g = Git.open(@path)
  end
end
