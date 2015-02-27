module GitTransactor
  class QueueManager
    def self.open(root)
      self.new(root)
    end
    private
    def initialize(root)
      @root = root
    end
  end
end
