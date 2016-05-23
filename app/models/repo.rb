class Repo
  def self.add_all(repos = [])
    repos = trim_repos_without_access(repos)
    REDIS.sadd(REPOSITORIES_KEY, repos)
  end

  def self.add(repo)
    REDIS.sadd(REPOSITORIES_KEY, repo)
  end

  def self.trim_repos_without_access(repos)
    repos.select { |repo| GITHUB.repo?(repo) }
  end

  def self.all
    REDIS.smembers(REPOSITORIES_KEY)
  end

  def self.watched?(repo)
    REDIS.sismember(REPOSITORIES_KEY, repo)
  end
end
