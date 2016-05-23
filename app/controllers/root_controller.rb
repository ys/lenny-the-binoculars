# Root route controller
class RootController < ApplicationController
  def index
    @repos = REDIS.smembers(REPOSITORIES_KEY)
  end
end
