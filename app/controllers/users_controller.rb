class UsersController < ApplicationController
  before_action :disallow_authenticated_users, only: [:new, :create]
  before_action :require_user, only: [:show]
  before_action :get_invitation, only: [:new, :create]

  def new
    @user = User.new
    @user.attributes = { name: @invitation.name, email: @invitation.email } if @invitation
  end

  def create
    @user = User.new(user_params)

    if @invitation
      @user.following_relationships.build(leader: @invitation.author)
      @user.leading_relationships.build(follower: @invitation.author)
    end

    if @user.save
      flash[:success] = "Welcome, #{@user.name}! Your account has been created, please login below."
      UserMailer.welcome(@user).deliver

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

  def get_invitation
    @invitation = Invitation.find_by(token: params[:token]) if params[:token].present?
  end

end
