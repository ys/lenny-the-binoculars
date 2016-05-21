class ReposController < ApplicationController
  def show
    @repo = Repo.new(name_with_owner: repo_name, sha: "master")
    @lockfile = @repo.check_lockfile!
  end

  def repo_name
   "#{params[:owner]}/#{params[:name]}"
  end
end
