# Api tokens controller
class TokensController < ApplicationController
  def index
    @tokens = ApiToken.all
  end

  def create
    ApiToken.create
    redirect_to tokens_path
  end
end
