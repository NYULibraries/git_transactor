# Helper methods to setup state for GitTransactor Processor examples
module GitTransactor
  module Setup
    module Processor
      def setup_initial_state
        tr = TestRepo.new(repo_path)
        tr.nuke
        tr.init
        ead = TestEAD.new('foo')
        tr.create_file('foo.txt', ead)
        tr.add('foo.txt')
        tr.commit('Initial commit')

        tq = TestQueue.new(work_root)
        tq.nuke
        tq.init

        tsd = TestSourceDir.new(source_path)
        tsd.nuke
        tsd.init
      end

      def setup_add_state
        sub_directory = 'jgp'
        src_file = "interesting-stuff.xml"

        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end

      def setup_add_state_2
        sub_directory_2 = 'khq'
        src_file_2 = 'more-interesting-stuff.xml'
        tsd.create_sub_directory(sub_directory_2)
        tsd.create_file(File.join(sub_directory_2, src_file_2), "#{src_file_2}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory_2, src_file_2)))
      end

      def setup_add_state_3
        sub_directory = 'jgp'
        src_file = "super-cool-stuff.xml"

        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end

      def setup_add_same_file_state
        setup_add_state
        sub_directory = 'jgp'
        src_file = "interesting-stuff.xml"

        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end

      def setup_add_same_subdir_state
        setup_add_state
        setup_add_state_3
      end

      def setup_rm_state
        sub_directory = 'pgj'
        eadid = 'spiffingly-interesting'
        ead = TestEAD.new(eadid)

        file_to_rm = "#{eadid}.xml"
        file_to_rm_rel_path = File.join(sub_directory, file_to_rm)

        tr.create_sub_directory(sub_directory)
        tr.create_file(file_to_rm_rel_path, ead)

        g = Git.open(repo_path)
        g.add(file_to_rm_rel_path)
        g.commit('add test file')

        tq.enqueue('rm', File.expand_path(File.join(source_path, file_to_rm_rel_path)))
      end

      def setup_rm_same_file_state
        setup_rm_state

        sub_directory = 'pgj'
        file_to_rm = 'spiffingly-interesting.xml'
        file_to_rm_rel_path = File.join(sub_directory, file_to_rm)

        tq.enqueue('rm', File.expand_path(File.join(source_path, file_to_rm_rel_path)))
      end

      def setup_push_state
        trr = TestRepo.new(remote_url, bare: true)
        trr.nuke
        trr.init

        td  = TestDir.new(local_repo_parent)
        td.nuke
        td.create_root

        Git.clone(trr.path, local_repo_name, path: td.path)

        local_repo = TestRepo.new(local_repo_path)
        local_repo.open
        local_repo.create_file('unicorns.txt', 'and rainbows!')
        local_repo.add('unicorns.txt')
        local_repo.commit('add unicorns and rainbows!')
      end

      def setup_pull_state
        # test remote repo
        trr = TestRepo.new(remote_url, bare: true)
        trr.nuke
        trr.init

        # clone here to capture current state of remote repo
        td  = TestDir.new(local_repo_parent)
        td.nuke
        td.create_root

        Git.clone(trr.path, local_repo_name, path: td.path)

        # create test temp repo
        ttd = TestDir.new(tmp_repo_parent)
        ttd.nuke
        ttd.create_root

        # clone the remote repo to tmp repo directory
        Git.clone(trr.path, local_repo_name, path: ttd.path)
        ttr = TestRepo.new(tmp_repo_path)
        ttr.open

        # update the tmp repo
        ttr.create_file('hotdog.txt', 'and mustard!')
        ttr.add('hotdog.txt')
        ttr.commit('add hotdog.txt')

        # push to remote repo
        ttr.push

        # clean house
        ttr.nuke
      end

      def setup_locked_state
        sub_directory = 'jgp'
        src_file = "interesting-stuff.xml"

        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
        qm = GitTransactor::QueueManager.open(tq.path)
        qm.lock!
      end
    end
  end
end
