module GitTransactor
  ##
  # class for working with Git Transactor Queue Entry files.
  class QueueEntry
    FILE_GLOB = '*.csv'
    attr_accessor :action, :path, :entry_path, :entry_name
    ALLOWABLE_ACTIONS = %w(add rm)
    def initialize(entry_path)
      @entry_path = entry_path
      @entry_name = File.basename(@entry_path)

      File.open(@entry_path) do |f|
        lines = f.readlines
        raise ArgumentError.new("Too many lines in request file: #{@entry_path}") unless lines.length == 1
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
