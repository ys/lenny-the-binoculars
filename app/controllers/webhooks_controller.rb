# GitHub webhooks receiver
class WebhooksController < ApplicationController
  before_action :verify_incoming_webhook_address!
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticated

  def create
    case event_type
    when "pull_request"
      handle_pull_request
      render json: {}, status: :accepted
    when "ping"
      render json: {}, status: :ok
    else
      render json: { error: "Non supported event type" }, status: :unprocessable_entity
    end
  end

  private

  def handle_pull_request
    request.body.rewind
    PullRequestJob.perform_later(
      request.headers["HTTP_X_GITHUB_DELIVERY"],
      request.body.read.force_encoding("utf-8")
    )
  end

  def event_type
    request.headers["HTTP_X_GITHUB_EVENT"]
  end

  def verify_incoming_webhook_address!
    source_ips = ["192.30.252.0/22"]
    if Rails.env.development?
      source_ips << "127.0.0.1/32"
    end
    if source_ips.any? { |block| IPAddr.new(block).include?(request.ip) }
      true
    else
      render json: {}, status: :forbidden
    end
  end
end
