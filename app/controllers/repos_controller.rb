# Controller showing one repo branch lockfile
class ReposController < ApplicationController
  def show
    @repo = Repo.new(name_with_owner: repo_name, sha: branch)
    @lockfile = @repo.check_lockfile!
  end

  def create
    Repo.add_all(repos)
    redirect_to "/"
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
