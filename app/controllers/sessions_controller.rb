class SessionsController < ApplicationController
  before_action :disallow_authenticated_users, only: [:new, :create]

  def new
    redirect_to home_path if user_logged_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name}"
      redirect_to home_path
    else
      flash.now[:danger] = "Incorrect email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've logged out, see you next time!"
    redirect_to root_path
  end

end