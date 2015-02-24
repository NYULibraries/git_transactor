Given(/^that the git repository exists$/) do
  @repo_path   = 'features/fixtures/repo'
  @source_path = 'features/fixtures/source'
  @work_root   = 'features/fixtures/work'

  @repo = TestRepo.new(@repo_path)
  @repo.nuke
  @repo.init
  @repo.create_file('foo.txt','foo.txt')
  @repo.add('foo.txt')
  @repo.commit('Initial commit')
end

Given(/^a source\-file directory exists$/) do
  @src_dir = TestSourceDir.new(@source_path)
  @src_dir.nuke
  @src_dir.init
end


When(/^I process the queue$/) do
  gt = GitTransactor::Base.new(repo_path:   @repo.path,
                               source_path: @src_dir.path,
                               work_root:   @work_root)
  gt.process_queue
end

Then(/^I should see "(.*?)" in the commit log$/) do |msg|
  g = Git.open(@repo.path)
  expect(g.log[0].message).to include(msg)
end

Given(/^a source\-file named "(.*?)" exists$/) do |rel_path|
  subdir = rel_path.split('/')[0]
  @src_dir.create_sub_directory(subdir)
  @src_dir.create_file(rel_path, 'whoa! this is SO foo!')
end

Given(/^the file "(.*?)" does not exist in the repository$/) do |rel_path|
   g = Git.open(@repo.path)
   match = g.status.select {|x| x.path == rel_path }
   expect(match).to be_empty
end

Given(/^the request queue exists$/) do
  @tq = TestQueue.new(@work_root); @tq.nuke; @tq.init
end

Given(/^there is an "(.*?)" request for "(.*?)" in the queue$/) do |action, rel_path|
  @tq.enqueue(action, File.expand_path(File.join(@src_dir.path, rel_path)))
end

Then(/^I should see "(.*?)" in the repository$/) do |rel_path|
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == rel_path }
  expect(match).to_not be_empty
end

Given(/^the file "(.*?)" exists in the repository$/) do |rel_path|
  subdir = rel_path.split('/')[0]
  @repo.create_sub_directory(subdir)
  @repo.create_file(rel_path, "#{rel_path}")

  g = Git.open(@repo.path)
  g.add(rel_path)
  g.commit("adding test file: #{rel_path}")
  match = g.status.select {|x| x.path == rel_path }
  expect(match).to_not be_empty
end
