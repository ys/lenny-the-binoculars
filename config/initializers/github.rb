require "octokit"

GITHUB = Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
