class ApplicationController < ActionController::Base
  protect_from_forgery

  def user_logged_in?
    !!session[:user_id]
  end
  helper_method :user_logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if user_logged_in?
  end
  helper_method :current_user

  private

  def require_user
    unless user_logged_in?
      flash[:warning] = "You need to be logged in to do that."
      redirect_to root_path
    end
  end

  def redirect_users_to_home
    redirect_to home_path if user_logged_in?
  end
end
