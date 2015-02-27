# Helper methods to setup state for GitTransactor Base examples
module GitTransactor
  module Setup
    module QueueManager
      def setup_valid_state
        tq = TestQueue.new(valid_root)
        tq.nuke
        tq.init
      end
      def setup_unreadable_root
        tq = TestQueue.new(unreadable_root)
        tq.nuke
        tq.init
        File.chmod(0333, unreadable_root)
      end
      def setup_unwritable_root
        tq = TestQueue.new(unwritable_root)
        tq.nuke
        tq.init
        File.chmod(0555, unwritable_root)
      end
    end
  end
end
