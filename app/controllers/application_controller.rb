class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

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

  def disallow_authenticated_users
    redirect_to home_path if user_logged_in?
  end

  def set_raven_context
    Raven.user_context(user_id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_hash, url: request.url)
  end
end
