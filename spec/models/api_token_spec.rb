require "rails_helper"

RSpec.describe ApiToken do
  it "creates tokens" do
    expect do
      ApiToken.create
    end.to change { ApiToken.all.size }.by(1)
  end
end
