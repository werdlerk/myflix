class UsersController < ApplicationController
  before_action :redirect_users_to_home, only: [:new, :create]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome, #{@user.name}! Your account has been created, please login below."
      UserMailer.send_welcome(@user).deliver

      redirect_to login_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

end