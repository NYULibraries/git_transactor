module GitTransactor
  ##
  # contains Git Transactor utility methods
  class Utils
    def self.source_path_to_repo_path(path)
      # current repo structure is <repo root>/<dir>/<file>
      File.absolute_path(path).split(File::SEPARATOR)[-2..-1]
        .join(File::SEPARATOR)
    end
  end
end
