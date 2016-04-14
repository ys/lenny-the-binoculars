class PullRequestsController < ApplicationController
  def show
    pr = PullRequests.find(params[:id])
    render json: pr.to_json
  end
end
