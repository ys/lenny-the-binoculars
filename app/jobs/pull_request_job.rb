require "json"

class PullRequestJob < ActiveJob::Base
  def perform(secret, pull_request_body)
    payload = JSON.parse(pull_request_body)
    pr = PullRequest.find_or_create_from_webhook(payload)
    lockfile = pr.check_lockfile!
    state = lockfile.vulnerable? ? "failure" : "success"
    pr.create_status(state)
  end
end
