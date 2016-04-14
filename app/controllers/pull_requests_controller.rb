class PullRequestsController < ApplicationController
  def show
    @pr = PullRequest.find(params[:id])
    @lockfile = @pr.check_lockfile!
    @lockfile.unpatched_gems.each do |g|
      puts g.advisory.inspect
    end
  end
end
