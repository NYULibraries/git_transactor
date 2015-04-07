Given(/^the remote repository has changes that the local repository does not$/) do

  # We need to create a temporary repo
  # in  which we commit some changes
  # and then push the temporary repo to the remote (bare) repo

  # directory in which we will clone remote repo
  tmp_parent_path = 'features/fixtures/tmp_repo'

  # create directory structure to hold tmp repo
  tmp_parent = TestDir.new(tmp_parent_path)
  tmp_parent.nuke

  # clone remote repo into tmp_repo_parent
  g = Git.clone(@remote_repo.path, @repo_name, path: tmp_parent_path)

  # create subdirectory in tmp_repo
  tmp_repo_path = File.join(tmp_parent_path, @repo_name)
  tmp_repo = TestRepo.new(tmp_repo_path)
  tmp_repo.open
  rel_path = 'oranges/blueberries.txt'
  subdir = rel_path.split('/')[0]
  tmp_repo.create_sub_directory(subdir)
  tmp_repo.create_file(rel_path, 'meaningless drivel')

  # use Git object to add file, commit, and push to remote
  g.add(rel_path)
  g.commit("Updating file #{rel_path}")
  g.push

  local_repo_head  = Git.ls_remote(@repo.path)['head'][:sha]
  remote_repo_head = Git.ls_remote(@remote_repo.path)['head'][:sha]
  expect(local_repo_head).not_to be == remote_repo_head

  # clean up
  tmp_parent.nuke
end

When(/^I pull the remote repository to the local repository$/) do
  gt = GitTransactor::Processor.new(repo_path:   @repo.path,
                                    source_path: 'features/fixtures/source',
                                    work_root:   'features/fixtures/work',
                                    remote_url:  @remote_repo_path )
  gt.pull
end
