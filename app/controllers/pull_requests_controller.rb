class PullRequestsController < ApplicationController
  def show
    @pr = PullRequests.find(params[:id])
    @lockfile = @pr.check_lockfile!
  end
end
