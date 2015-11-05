class PasswordsController < ApplicationController
  before_action :redirect_users_to_home
  before_action :require_valid_token, only: [:edit, :update]

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.reset_token = SecureRandom.urlsafe_base64
      user.reset_token_expiration = 2.hours.from_now
      user.save!

      UserMailer.send_reset_password(user).deliver
    else
      flash.now[:warning] = "The given e-mail address can't be found. If you want to use this e-mail address, please sign up."
      render 'new'
    end
  end

  def update
    user = User.find_by(reset_token: params[:token])
    user.password = params[:password]
    user.reset_token = nil
    user.reset_token_expiration = nil
    user.save!

    flash[:success] = "Your password has been changed. You can now login with the new password."
    redirect_to login_path
  end


  private

  def require_valid_token
    user = User.find_by(reset_token: params[:token])

    unless user.present? && params[:token].present? && user.reset_token_expiration >= DateTime.now
      render 'invalid_token'
    end
  end

end