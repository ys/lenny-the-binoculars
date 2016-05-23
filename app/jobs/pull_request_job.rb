require "json"

# Pull request handler to create the object and the commit status
class PullRequestJob < ActiveJob::Base
  def perform(_secret, pull_request_body)
    payload = JSON.parse(pull_request_body)
    return unless %w{opened synchronize}.include?(payload["action"])
    return unless watch_repo?(payload["repository"]["full_name"])
    create_status(payload)
  end

  def create_status(payload)
    pr = PullRequest.find_or_create_from_webhook(payload)
    pr.sha = payload["pull_request"]["head"]["sha"]
    pr.save
    lockfile = pr.check_lockfile!
    pr.create_status(lockfile.state, lockfile.description)
  end

  def watch_repo?(repo)
    REDIS.sismember(REPOSITORIES_KEY, repo)
  end
end
