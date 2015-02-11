module GitTransactor
  class QueueEntry
    attr_accessor :action, :path
    def initialize(path)
      File.open(path) do |f|
        lines = f.readlines
        raise ArgumentError.new("Too many lines in request file: #{path}") unless lines.length == 1
        @action, @path = lines[0].split(',')
      end
    end
  end
end
