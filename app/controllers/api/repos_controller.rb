class Api::ReposController < Api::BaseController
  def show
    lockfile = repo.check_lockfile!
    render json: { name: repo.name_with_owner, sha: repo.sha }.merge(lockfile.to_h)
  end
end
