# Represent a repository with a branch
class Repo
  include ActiveModel::Model

  attr_accessor :name_with_owner, :sha

  REPOSITORIES_KEY = "#{Rails.env}.lenny.repositories".freeze

  def self.add_all(repos = [])
    repos = trim_repos_without_access(Array(repos))
    REDIS.sadd(REPOSITORIES_KEY, repos) if repos.any?
  end

  def self.add(repo)
    REDIS.sadd(REPOSITORIES_KEY, repo)
  end

  def self.trim_repos_without_access(repos)
    repos.select { |repo| GITHUB.repository?(repo) }
  end

  def self.all
    if REDIS.exists(REPOSITORIES_KEY)
      REDIS.smembers(REPOSITORIES_KEY)
    else
      ENV.fetch("REPOSITORIES", "").split(",")
    end
  end

  def self.watched?(repo)
    REDIS.sismember(REPOSITORIES_KEY, repo)
  end

  def check_lockfile!
    raise(StandardError, "No Gemfile.lock found") unless gemfile?
    write_gemfile_in_local_folder
    lockfile = Lockfile.new(local_folder)
    lockfile.scan
    lockfile
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
    github.contents(name_with_owner, ref: sha, path: file)["content"]
  end

  def github
    Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
  end
end
