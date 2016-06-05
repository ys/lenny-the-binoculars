class Api::ReposController < ApplicationController
  skip_before_action :authenticated
  before_action :api_authenticated

  def show
    lockfile = repo.check_lockfile!
    render json: lockfile.to_json
  end

  def api_authenticated
    ApiToken.valid?(api_token)
  end

  def api_token
    request.authorization.split(" ")[1]
  end
end
