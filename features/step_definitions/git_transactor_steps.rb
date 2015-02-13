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

When(/^I process the queue$/) do
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

Given(/^the source\-file to be removed exists in the git repository$/) do
  @file_to_rm = 'file-to-rm.xml'
  @sub_dir    = 'quux'
  FileUtils.mkdir(File.join(@repo.path, @sub_dir))
  @file_to_rm_rel_path = File.join(@sub_dir, @file_to_rm)
  File.open(File.join(@repo.path, @file_to_rm_rel_path), "w") do |f|
    f.puts("#{@file_to_rm_rel_path}")
  end
  g = Git.open(@repo.path)
  g.add(@file_to_rm_rel_path)
  g.commit("adding test file: #{@file_to_rm_rel_path}")
  match = g.status.select {|x| x.path == @file_to_rm_rel_path }
  expect(match).to_not be_empty
end

Given(/^there is an rm\-request for the file$/) do
  tq = TestQueue.new(@work_root); tq.nuke; tq.init
  # N.B. the application doing the enqueuing will provide the path of the
  #      _original_ source file.
  tq.enqueue('rm', File.expand_path(File.join(@src_dir.path, @file_to_rm_rel_path)))
end


Then(/^I should not see the file in the repository$/) do
  pending # express the regexp above with the code you wish you had
end
