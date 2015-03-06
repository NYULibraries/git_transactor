require 'open3'

When(/^I execute the process and push Rake task$/) do
  _, e, s = Open3.capture3("rake git_transactor:process_and_push LOCAL_REPO='#{@repo_path}' SOURCE_PATH='#{@src_dir.path}' QUEUE_ROOT='#{@work_root}' REMOTE_REPO_URL='#{@remote_repo_path}'")
  raise RuntimeError.new(e)unless s == 0
end

