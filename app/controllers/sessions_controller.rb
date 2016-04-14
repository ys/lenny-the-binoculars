class SessionsController < ApplicationController
  skip_before_action :authenticated

  def github
    client = Octokit::Client.new(:access_token => auth_hash["credentials"]["token"])
    if client.org_member?(ENV["GITHUB_ORG"], client.user.login)
      session[:authenticated] = true
    else
      return render :json => { error: "Not a member of the correct org, sorry" }, :status => :forbidden
    end
    redirect_to env["omniauth.params"]["origin"] || "/"
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
