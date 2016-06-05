class Api::ReposController < Api::BaseController
  def show
    lockfile = repo.check_lockfile!
    render json: lockfile.to_json
  end
end
