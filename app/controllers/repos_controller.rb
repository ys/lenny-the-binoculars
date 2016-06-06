# Controller showing one repo branch lockfile
class ReposController < ApplicationController
  def show
    @repo = repo
    @lockfile = @repo.gemfile? ? @repo.check_lockfile! : nil
  end

  def create
    Repo.add_all(repos)
    redirect_to "/"
  end
end
