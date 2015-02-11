module GitTransactor
  class QueueEntry
    attr_accessor :action, :path
    ALLOWABLE_ACTIONS = %q(add rm)
    def initialize(path)
      File.open(path) do |f|
        lines = f.readlines
        raise ArgumentError.new("Too many lines in request file: #{path}") unless lines.length == 1
        @action, @path = lines[0].split(',')
        raise ArgumentError.new("Invalid action: #{@action}") unless ALLOWABLE_ACTIONS.include?(@action)
      end
    end
  end
end
