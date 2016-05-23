require "rails_helper"

RSpec.describe PullRequest, type: :model do
  it "gets the gemfile.lock" do
    pr = PullRequest.new(repository: "ys/lenny-the-binoculars", sha: "master")
    stub_json_request(:get, "https://api.github.com/repos/ys/lenny-the-binoculars/contents/Gemfile.lock?ref=master", fixture_data("github/gemfile_lock"))
    expect(pr.gemfile_lock).to_not be_nil
  end
end
