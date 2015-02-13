Given(/^a source\-file named "(.*?)" exists$/) do |rel_path|
  subdir = rel_path.split('/')[0]
  @src_dir.create_sub_directory(subdir)
  @src_dir.create_file(rel_path, 'whoa! this is SO foo!')
end

Given(/^the file "(.*?)" does not exist in the repo$/) do |rel_path|
   g = Git.open(@repo.path)
   match = g.status.select {|x| x.path == rel_path }
   expect(match).to be_empty
end

Given(/^there is a request queue$/) do
  @tq = TestQueue.new(@work_root); @tq.nuke; @tq.init
end
Given(/^there is an add\-request for "(.*?)" in the queue$/) do |rel_path|
  @tq.enqueue('add', File.expand_path(File.join(@src_dir.path, rel_path)))
end

Then(/^I should see "(.*?)" in the repository$/) do |rel_path|
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == rel_path }
  expect(match).to_not be_empty
end
