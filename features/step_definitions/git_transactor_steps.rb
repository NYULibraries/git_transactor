Given(/^that the git repository exists$/) do
  @repo = TestRepo.new
  @repo.nuke
  @repo.init
end

Given(/^a source\-file directory exists$/) do
  @src_dir = TestSourceDir.new
  @src_dir.nuke
  @src_dir.init
end

Given(/^a file to be added to the repo exists$/) do
  @src_file = "#{Random.rand 99999}.txt"
  @src_dir.create_file(@src_file, 'whoa! this is SO foo!')
end

Given(/^the source\-file does not exist in the git repository$/) do
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == @src_file }
  expect(match).to be_empty
end

Given(/^there is an add\-request for the file$/) do
  queue_dir = 'work/queue'
  request_fname = "#{Time.now.strftime("%Y%m%dT%H%M%S")}.csv"
  path = File.join(File.expand_path(@src_dir.path), @src_file)
  File.open(File.join(queue_dir, request_fname), 'w') do |f|
    f.puts("add,#{path}")
  end
end

When(/^I process the add\-request$/) do
  rq = GitTransactor::RequestQueue.new
  rq.process
end

Then(/^I should see the file in the repository$/) do
  g = Git.open(@repo.path)
  match = g.status.select {|x| x.path == @src_file }
  expect(match).to_not be_empty
end

Then(/^I should see "(.*?)" in the commit log$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
