def nuke_repo(repo)
  FileUtils.rm_rf(repo) if File.exists?(repo)
end

def create_file(path, msg)
  File.open(path, 'w') {|f| f.puts(msg)}
end

def init_repo(repo)
  FileUtils.mkdir(repo)
  g = Git.init(repo)
  dummy_file = "#{repo}/foo.txt"
  create_file(dummy_file, dummy_file)
  g.add(File.basename(dummy_file))
  g.commit('Initial commit')
end

Given(/^that the git repository exists$/) do
  repo = 'tmp/repo'
  nuke_repo(repo)
  init_repo(repo)
end

Given(/^a file to be added to the repo exists$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^the file does not exist in the git repository$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is an add\-request for the file$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I process the add\-request$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the file in the repository$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)" in the commit log$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
