class Api::BaseController < ApplicationController
  skip_before_action :authenticated
  before_action :api_authenticated

  def api_authenticated
    return if ApiToken.valid?(api_token)
    render json: {}, status: :forbidden
  end

  def api_token
    return "" unless request.authorization
    request.authorization.split(" ")[1]
  end

  def root
    render json: {}, status: 200
  end
end
