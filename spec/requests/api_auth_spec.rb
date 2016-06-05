require "rails_helper"

RSpec.describe "Api authentication" do
  it "uses ApiToken" do
    get "/api"
    expect(status).to eql 403

    token = ApiToken.create
    get "/api", headers: { "Authorization" => "Token #{token}" }
    expect(status).to eql 200
  end
end
