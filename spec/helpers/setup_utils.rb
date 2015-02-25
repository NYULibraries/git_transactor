module GitTransactor
  module SetupUtils
    def setup_add_state
      tsd.create_sub_directory(sub_directory)
      tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
      tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
    end

    def setup_add_state_2
      tsd.create_sub_directory(sub_directory_2)
      tsd.create_file(File.join(sub_directory_2, src_file_2), "#{src_file_2}")
      tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory_2, src_file_2)))
    end

    def setup_rm_state
      tr.create_sub_directory(sub_directory)
      tr.create_file(file_to_rm_rel_path, "#{file_to_rm}")

      g = Git.open(repo_path)
      g.add(file_to_rm_rel_path)
      g.commit("add test file")

      tq.enqueue('rm', File.expand_path(File.join(source_path, file_to_rm_rel_path)))
    end
  end
end
