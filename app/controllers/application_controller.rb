class ApplicationController < ActionController::Base
  protect_from_forgery

  def authorized?
    @user = User.find(session[:user_id]) if session[:user_id]
  end
end
