# Pull requests controller to show the outdated gems
class PullRequestsController < ApplicationController
  def show
    @pr = PullRequest.find(params[:id])
    @lockfile = @pr.check_lockfile!
  end
end
