class SessionsController < ApplicationController

  def new
    session[:login_referrer] = request.referrer if request.referrer
    session[:user_id] = nil if user_logged_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name}"

      if session[:login_referrer]
        redirect_to session.delete(:login_referrer)
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Incorrect email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've logged out, see you next time!"

    if request.referrer && request.referrer != logout_url
      redirect_to request.referrer
    else
      redirect_to root_path
    end
  end

end