module GitTransactor
  class QueueEntry
    attr_accessor :action, :path
    ALLOWABLE_ACTIONS = %q(add rm)
    def initialize(path)
      File.open(path) do |f|
        lines = f.readlines
        raise ArgumentError.new("Too many lines in request file: #{path}") unless lines.length == 1
        @action, @path = lines[0].chomp.split(',',2)
        raise ArgumentError.new("Invalid action: #{@action}") unless ALLOWABLE_ACTIONS.include?(@action)
      end
      def add?
        @action == 'add'
      end
      def rm?
        @action == 'rm'
      end
    end
  end
end