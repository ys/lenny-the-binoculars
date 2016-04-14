require "rails_helper"

describe "Receiving GitHub hooks", :type => :request do
  def request_headers(event = "ping", remote_ip = "192.30.252.41")
    uuid = SecureRandom.uuid
    {
      "REMOTE_ADDR": remote_ip,
      "X_FORWARDED_FOR": remote_ip,
      "X-Github-Event": event,
      "X-Github-Delivery": uuid
    }
  end

  describe "POST /webhooks" do
    describe "Hosts verification" do
      it "returns a forbidden error to invalid hosts" do
        post "/webhooks", fixture_data("github/ping"), request_headers("ping", "74.125.239.105")

        expect(response).to be_forbidden
        expect(response.status).to eql(403)
      end

      it "returns a unprocessable error for invalid events" do
        post "/webhooks", "{}", request_headers("invalid")

        expect(response.status).to eql(422)
      end

      it "handles ping events from valid hosts" do
        post "/webhooks", fixture_data("github/ping"), request_headers

        expect(response).to be_successful
        expect(response.status).to eql(200)
      end
    end

    describe "Pull Request events" do
      it "creates a pull request object on open event" do
        post "/webhooks", fixture_data("github/pull_request_open"), request_headers("pull_request")

        expect(response).to be_successful
        expect(response.status).to eql(200)
      end
    end
  end
end
