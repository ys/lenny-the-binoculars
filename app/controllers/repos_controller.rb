class ReposController < ApplicationController
  def create
    Repo.add_all(repos)
    redirect_to "/"
  end

  def repos
    params[:repos].split(",").map(&:strip)
  end
end
