Given(/^that the git repository exists$/) do
  @repo_path   = 'features/fixtures/repo'
  @source_path = 'features/fixtures/source'
  @work_root   = 'features/fixtures/work'

  @repo = TestRepo.new(@repo_path)
  @repo.nuke
  @repo.init
end

Given(/^a source\-file directory exists$/) do
  @src_dir = TestSourceDir.new(@source_path)
  @src_dir.nuke
  @src_dir.init
end

Given(/^a file to be added to the repo exists$/) do
  @src_file = "way-cool-example.xml"
  @sub_dir = 'baz'
  @src_file_rel_path = File.join(@sub_dir, @src_file)
  @src_dir.create_sub_directory(@sub_dir)
  @src_dir.create_file(@src_file_rel_path, 'whoa! this is SO foo!')
end

Given(/^the source\-file does not exist in the git repository$/) do
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == @src_file_rel_path }
  expect(match).to be_empty
end

Given(/^there is an add\-request for the file$/) do
  tq = TestQueue.new(@work_root); tq.nuke; tq.init
  tq.enqueue('add', File.expand_path(File.join(@src_dir.path, @src_file_rel_path)))
end

When(/^I process the add\-request$/) do
  gt = GitTransactor::Base.new(repo_path:   @repo.path,
                               source_path: @src_dir.path,
                               work_root:   @work_root)
  gt.process_queue
end

Then(/^I should see the file in the repository$/) do
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == @src_file_rel_path }
  expect(match).to_not be_empty
end

Then(/^I should see "(.*?)" in the commit log$/) do |arg1|
  g = Git.open(@repo.path)
  expect(g.log[0].message).to include("Updating file #{@src_file_rel_path}")
end
