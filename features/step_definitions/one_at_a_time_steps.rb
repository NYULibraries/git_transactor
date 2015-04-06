Given(/^the request queue is locked by another process$/) do
  qm = GitTransactor::QueueManager.open(@work_root)
  qm.lock!
end

When(/^I try to run rake "(.*?)"$/) do |task|
  @o, @e, @s = Open3.capture3("rake #{task} LOCAL_REPO='#{@repo_path}' SOURCE_PATH='#{@src_dir.path}' QUEUE_ROOT='#{@work_root}' REMOTE_REPO_URL='#{@remote_repo_path}'")
end

Then(/^"(.*?)" should be output to "(.*?)"$/) do |text, fd|
  output = case fd
          when "stderr" then @e
          when "stdout" then @o
          else fail "unrecognized file descriptor"
          end
  expect(output).to match(/#{text}/)
end

Then(/^the exit status should be "(.*?)"$/) do |status|
  expect(status.to_i).to be == @s.exitstatus
end
