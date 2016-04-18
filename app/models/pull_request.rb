require "base64"
require "tmpdir"

# Pull request object
class PullRequest < ApplicationRecord
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
                         context: "lenny/vulnerabilities",
                         description: description,
                         target_url: "#{ENV['APP_URL']}/pull_requests/#{id}")
  end

  def check_lockfile!
    raise(StandardError, "No Gemfile.lock found") unless gemfile?
    write_gemfile_in_local_folder
    lockfile = Lockfile.new(local_folder)
    lockfile.scan
    lockfile
  end

  def name
    "#{repository}##{number}"
  end

  def gemfile?
    gemfile_lock
    true
  rescue Octokit::NotFound
    false
  end

  def gemfile_lock
    @content ||= begin
      encoded_content = github_file("Gemfile.lock")
      Base64.decode64(encoded_content)
    end
  end

  private

  def write_gemfile_in_local_folder
    File.open(File.join(local_folder, "Gemfile.lock"), "w") do |f|
      f.write gemfile_lock
    end
  end

  def local_folder
    @local_folder ||= Dir.tmpdir
  end

  def github_file(file)
    github.contents(repository, ref: sha, path: file)["content"]
  end

  def github
    Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
  end
end
