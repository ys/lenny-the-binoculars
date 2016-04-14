require "json"

class PullRequestJob < ActiveJob::Base
  def perform(secret, pull_request_body)
    payload = JSON.parse(pull_request_body)
    return unless %w{opened synchronize}.include?(payload["action"])
    return unless repositories.include?(payload["repository"]["full_name"])
    pr = PullRequest.find_or_create_from_webhook(payload)
    pr.sha = payload["pull_request"]["head"]["sha"]
    pr.save
    lockfile = pr.check_lockfile!
    state = lockfile.vulnerable? ? "failure" : "success"
    description = if lockfile.vulnerable?
      "#{lockfile.insecure_sources_count} insecure sources, #{lockfile.unpatched_gems_count} unpatched Gems"
      else
        "No vulnerabilities found"
      end
    pr.create_status(state, description)
  end

  def repositories
    JSON.parse(File.read(File.join(Rails.root, "config", "repositories.json")))
  end
end
