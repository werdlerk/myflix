class UsersController < ApplicationController
  before_action :disallow_authenticated_users, only: [:new, :create]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation
    @invitation = Invitation.where(token: params[:token]).first

    if @invitation
      @user = User.new( name: @invitation.name, email: @invitation.email )
      render 'new'
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(stripe_token: params[:stripeToken], invitation_token: params[:invitation_token])

    if result.succesful?
      flash[:success] = "Welcome, #{@user.name}! Your account has been created, please login below."
      redirect_to login_path
    else
      flash[:danger] = result.error_message
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
