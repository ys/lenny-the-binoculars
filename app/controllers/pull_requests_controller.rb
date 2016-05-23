# Pull requests controller to show the outdated gems
class PullRequestsController < ApplicationController
  def index
    @pull_requests = PullRequest.order(created_at: :desc).page(params[:page])
  end

  def show
    @pr = PullRequest.find(params[:id])
    @lockfile = @pr.check_lockfile!
  end
end
