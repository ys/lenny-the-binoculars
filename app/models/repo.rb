class Repo
  REPOSITORIES_KEY = "#{Rails.env}.lenny.repositories".freeze

  def self.add_all(repos = [])
    repos = trim_repos_without_access(repos)
    REDIS.sadd(REPOSITORIES_KEY, repos)
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
      ENV["REPOSITORIES"].split(",")
    end
  end

  def self.watched?(repo)
    REDIS.sismember(REPOSITORIES_KEY, repo)
  end
end
