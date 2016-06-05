# Helper for managing params for repo
module ReposHelper
  def repo
    Repo.new(name_with_owner: repo_name, sha: branch)
  end

  def repo_name
    "#{params[:owner]}/#{params[:name]}"
  end

  def branch
    params[:branch] || "master"
  end

  def repos
    params[:repos].split(",").map(&:strip)
  end
end
