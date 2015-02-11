require 'git'

module GitTransactor
  class Base
    def initialize(params)
      @errors = {}
      [:repo_path, :source_path, :work_root].each do |key|
        @errors[key] = "missing #{key}:" if params[key].nil?
      end
      raise ArgumentError.new(@errors.to_s) unless @errors.empty?

      @repo_path   = params[:repo_path]
      @source_path = params[:source_path]
      @work_root   = params[:work_root]

      @repo = Git.open(@repo_path)
    end

    def process_queue
      0
    end
  end
end
