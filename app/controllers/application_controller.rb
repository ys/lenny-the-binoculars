# Base controller for the app
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception
  before_action :authenticated

  def authenticated
    return redirect_to "/auth/github?origin=#{request.original_url}" unless session[:authenticated]
  end
end
