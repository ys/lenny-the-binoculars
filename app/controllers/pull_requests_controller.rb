class PullRequestsController < ApplicationController
  def show
    @pr = PullRequest.find(params[:id])
    @lockfile = @pr.check_lockfile!
  end
end
