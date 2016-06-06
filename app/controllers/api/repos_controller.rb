# Repos in json
class Api::ReposController < Api::BaseController
  def show
    return render(json: { error: "No lockfile found" }, status: :not_found) unless repo.gemfile?
    lockfile = repo.check_lockfile!
    render json: { name: repo.name_with_owner, sha: repo.sha }.merge(lockfile.to_h)
  end
end
