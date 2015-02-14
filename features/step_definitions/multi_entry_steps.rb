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
