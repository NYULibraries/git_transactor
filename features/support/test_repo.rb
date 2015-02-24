require 'forwardable'

class TestRepo < TestDir
  attr_reader :path

  extend Forwardable
  def_delegators :@g, :add, :commit, :status

  def init
    create_root
    @g = Git.init(@path, @options)
    dummy_file = 'foo.txt'
    create_file(dummy_file,dummy_file)
    @g.add(dummy_file)
    @g.commit('Initial commit')
  end

  def open
    @g = Git.open(@path)
  end
end
