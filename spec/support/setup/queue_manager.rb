# Helper methods to setup state for GitTransactor Base examples
module GitTransactor
  module Setup
    module QueueManager
      def setup_valid_state
        tq = TestQueue.new(valid_root)
        tq.nuke
        tq.init
      end
    end
  end
end
