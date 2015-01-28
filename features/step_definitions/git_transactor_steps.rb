Given(/^that the git repository exists$/) do
  repo = TestRepo.new
  repo.nuke
  repo.init
end

Given(/^a file to be added to the repo exists$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^a source\-file directory exists$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^the source\-file does not exist in the git repository$/) do
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
