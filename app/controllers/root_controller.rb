# Root route controller
class RootController < ApplicationController
  def index
    @repos = Repo.all
  end
end
