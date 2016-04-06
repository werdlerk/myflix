class SessionsController < ApplicationController
  before_action :disallow_authenticated_users, only: [:new, :create]

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password]) && !user.blocked?
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name}"

      if user.admin?
        redirect_to admin_path
      else
        redirect_to home_path
      end
    elsif user.try(:blocked?)
      flash.now[:danger] = "Your account has been blocked"
      render :new
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
