require "rails_helper"

describe "Receiving GitHub hooks", :type => :request do
  def request_headers(event = "ping", remote_ip = "192.30.252.41")
    uuid = SecureRandom.uuid
    {
      :headers => {
        "REMOTE_ADDR": remote_ip,
        "X_FORWARDED_FOR": remote_ip,
        "X-Github-Event": event,
        "X-Github-Delivery": uuid
      },
      :as => :json
    }
  end

  describe "POST /webhooks" do
    describe "Hosts verification" do
      it "returns a forbidden error to invalid hosts" do
        post "/webhooks", { params: fixture_json("github/ping") }.merge(request_headers("ping", "74.125.239.105"))

        expect(response).to be_forbidden
        expect(response.status).to eql(403)
      end

      it "returns a unprocessable error for invalid events" do
        post "/webhooks", { params: {} }.merge(request_headers("invalid"))

        expect(response.status).to eql(422)
      end

      it "handles ping events from valid hosts" do
        post "/webhooks", { params: fixture_json("github/ping") }.merge(request_headers)

        expect(response).to be_successful
        expect(response.status).to eql(200)
      end
    end

    describe "Pull Request events" do
      it "creates a pull request object on open event" do
        Repo.add("ys/lenny-the-binoculars")
        stub_github(:get,
                    "/repos/ys/lenny-the-binoculars/contents/Gemfile.lock?ref=ddd3c786004a813aef53caf5661c5fba5f30ebed",
                    fixture_data("github/gemfile_lock"))
        stub_github(:post, "/repos/ys/lenny-the-binoculars/statuses/ddd3c786004a813aef53caf5661c5fba5f30ebed", "{}")
        post "/webhooks", { params: fixture_json("github/pull_request_open") }.merge(request_headers("pull_request"))
        expect(PullRequest.last).to_not be_nil
        expect(response).to be_successful
        expect(response.status).to eql(202)
      end

      it "does not create a pull request object if repo is not participating" do
        Repo.add("lol/sob")
        post "/webhooks", { params: fixture_json("github/pull_request_open") }.merge(request_headers("pull_request"))
        expect(PullRequest.last).to be_nil
        expect(response).to be_successful
        expect(response.status).to eql(202)
      end
    end
  end
end
