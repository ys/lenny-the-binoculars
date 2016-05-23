require "rails_helper"

RSpec.describe Repo do
  it "add repos if they exist" do
    stub_github(:get, "/repos/ys/lenny-the-binoculars", "{}")
    expect do
      Repo.add_all("ys/lenny-the-binoculars")
    end.to change { Repo.all.size }.to(1)
  end

  it "does not add repo if they do not exist" do
    stub_github(:get, "/repos/ys/NOT_LENNY", "{}", 404)
    expect do
      Repo.add_all("ys/NOT_LENNY")
    end.to_not change { Repo.all.size }
  end

  it "returns a list of the repos" do
    stub_github(:get, "/repos/ys/lenny-the-binoculars", "{}")
    Repo.add_all("ys/lenny-the-binoculars")

    expect(Repo.all).to eql(["ys/lenny-the-binoculars"])
  end

  it "tells which repos are watched" do
    stub_github(:get, "/repos/ys/lenny-the-binoculars", "{}")
    Repo.add_all("ys/lenny-the-binoculars")

    expect(Repo.watched?("ys/lenny-the-binoculars")).to be_truthy
    expect(Repo.watched?("ys/not-watched")).to be_falsy
  end
end
