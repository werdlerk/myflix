class SessionsController < ApplicationController
  before_action :redirect_users_to_home, only: [:new, :create]

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