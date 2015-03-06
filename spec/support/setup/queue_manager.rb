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
      def teardown_unreadable_root
        File.chmod(0755, unreadable_root)
      end
      def setup_unwritable_root
        tq = TestQueue.new(unwritable_root)
        tq.nuke
        tq.init
        File.chmod(0555, unwritable_root)
      end
      def teardown_unwritable_root
        File.chmod(0755, unwritable_root)
      end
      def setup_unexecutable_root
        tq = TestQueue.new(unexecutable_root)
        tq.nuke
        tq.init
        File.chmod(0666, unexecutable_root)
      end
      def teardown_unexecutable_root
        File.chmod(0755, unexecutable_root)
      end
      def setup_malformed_root
        tq = TestQueue.new(malformed_root)
        tq.nuke
        tq.init
        Dir.rmdir(malformed_root + '/queue')
      end
      def setup_valid_create
        tq = TestQueue.new(valid_create)
        tq.nuke
      end
      def setup_invalid_create
        td = TestDir.new(File.dirname(invalid_create))
        td.nuke
        td.create_root
        File.chmod(0555, File.dirname(invalid_create))
      end
      def teardown_invalid_create
        File.chmod(0755, File.dirname(invalid_create))
      end
      def setup_empty_queue
        tq = TestQueue.new(empty_queue)
        tq.nuke
        tq.init
      end
      def setup_populated_queue
        tq = TestQueue.new(populated_queue)
        tq.nuke
        tq.init
        tq.add_failed('rm','apples')
        tq.add_passed('add','peaches')
        tq.add_passed('rm','pumpkin')
        tq.add_passed('add','pie')
        tq.enqueue('rm','cake')
        tq.enqueue('rm','doughnuts')
      end
    end
  end
end
