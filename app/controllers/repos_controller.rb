# Controller showing one repo branch lockfile
class ReposController < ApplicationController
  def show
    @repo = repo
    @lockfile = @repo.check_lockfile!
  end

  def create
    Repo.add_all(repos)
    redirect_to "/"
  end
end
