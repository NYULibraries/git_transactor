require 'open3'

Given(/^that a parent directory exists$/) do
  td = TestDir.new('features/fixtures/setup_queue')
  td.nuke
  td.create_root
end

When(/^I setup the queue$/) do
  _, e, s = Open3.capture3('rake git_transactor:setup:queue QUEUE_ROOT=features/fixtures/setup_queue/queue')
  raise RuntimeError.new(e)unless s == 0
end

Then(/^I should be able to use the queue$/) do
  GitTransactor::QueueManager.open('features/fixtures/setup_queue/queue')
end
