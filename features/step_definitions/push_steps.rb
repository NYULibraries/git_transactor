Given(/^that the remote repository exists$/) do
  @remote_repo_path = 'features/fixtures/remote_repo/blerf'

  @remote_repo = TestRepo.new(@remote_repo_path, bare: true)
  @remote_repo.nuke
  @remote_repo.init
end

Given(/^that the local repository exists and was cloned from the remote repository$/) do
  @repo_parent = 'features/fixtures/local_repo'
  td = TestDir.new(@repo_parent)
  td.nuke
  @repo_name = 'blerf'
  @repo_path = File.join(@repo_parent, @repo_name)
  Git.clone(@remote_repo.path, @repo_name, path: @repo_parent)
  @repo = TestRepo.new(@repo_path)
  @repo.open
  local_repo_head  = Git.ls_remote(@repo.path)['head'][:sha]
  remote_repo_head = Git.ls_remote(@remote_repo.path)['head'][:sha]
  expect(local_repo_head).to be == remote_repo_head
end

Given(/^the local repository has changes that the remote repository does not$/) do
  rel_path = 'oranges/blueberries.txt'
  subdir = rel_path.split('/')[0]

  @repo.create_sub_directory(subdir)
  @repo.create_file(rel_path, 'meaningless drivel')
  @repo.add(rel_path)
  @repo.commit("Updating file #{rel_path}")
  local_repo_head = Git.ls_remote(@repo.path)['head'][:sha]
  remote_repo_head = Git.ls_remote(@remote_repo.path)['head'][:sha]
  expect(local_repo_head).not_to be == remote_repo_head
end

When(/^I push the local repository to the remote repository$/) do
  gt = GitTransactor::Processor.new(repo_path:   @repo.path,
                                    source_path: 'features/fixtures/source',
                                    work_root:   'features/fixtures/work',
                                    remote_url:  @remote_repo_path )
  gt.push
end

Then(/^the local repository and the remote repository should be in the same state$/) do
  local_repo_head  = Git.ls_remote(@repo.path)['head'][:sha]
  remote_repo_head = Git.ls_remote(@remote_repo.path)['head'][:sha]
  expect(local_repo_head).to be == remote_repo_head
end
