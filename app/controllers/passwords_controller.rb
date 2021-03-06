class PasswordsController < ApplicationController
  before_action :disallow_authenticated_users
  before_action :require_valid_token, only: [:edit, :update]

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.token = SecureRandom.urlsafe_base64
      user.token_expiration = 2.hours.from_now
      user.save!

      UserMailer.delay.reset_password(user.id)
    else
      flash.now[:warning] = "The given e-mail address can't be found. If you want to use this e-mail address, please sign up."
      render 'new'
    end
  end

  def update
    @user = User.find_by(token: params[:token])

    if @user.present? && @user.update(password: params[:password])
      @user.clear_token!

      flash[:success] = "Your password has been changed. You can now login with the new password."
      redirect_to login_path

    elsif user.present?
      render 'edit'

    else
      redirect_to invalid_token_path
    end
  end


  private

  def require_valid_token
    user = User.find_by(token: params[:token])

    unless user.present? && params[:token].present? && !user.token_expired?
      redirect_to invalid_token_path
    end
  end

end
