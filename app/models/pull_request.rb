require "base64"
require "tmpdir"

# Pull request object
class PullRequest < ApplicationRecord
  delegate :check_lockfile!, :gemfile_lock, to: :repo
  def self.find_or_create_from_webhook(payload)
    number = payload["number"]
    repository = payload["repository"]["full_name"]
    find_by(number: number, repository: repository) ||
      create(number: number,
             repository: repository,
             sha: payload["pull_request"]["head"]["sha"],
             raw_payload: payload)
  end

  def create_status(state, description)
    github.create_status(repository, sha, state,
                         context: "vulnerabilities/gems",
                         description: description,
                         target_url: "#{ENV['APP_URL']}/pull_requests/#{id}")
  end

  def repo
    @repo = Repo.new(name_with_owner: repository, sha: sha)
  end

  def name
    "#{repository}##{number}"
  end

  private

  def github
    Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
  end
end
