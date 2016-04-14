require "json"

class PullRequestJob < ActiveJob::Base
  def perform(secret, pull_request_body)
    payload = JSON.parse(pull_request_body)
    return unless %w{opened synchronize}.include?(payload["action"])
    unless repositories.include?(payload["repository"]["full_name"])
      Rails.logger.info"#{payload["repository"]["full_name"]} is not in #{repositories}"
      return
    end
    pr = PullRequest.find_or_create_from_webhook(payload)
    pr.sha = payload["pull_request"]["head"]["sha"]
    pr.save
    lockfile = pr.check_lockfile!
    pr.create_status(lockfile.state, lockfile.description)
  end

  def repositories
    ENV["REPOSITORIES"].split(",")
  end
end
