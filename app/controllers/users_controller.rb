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

    if @user.valid?
      charge = StripeWrapper::Charge.create(token: params[:stripeToken], customer: @user.name, amount: 999, description: "MyFLiX Signup fee for #{@user.email}")

      if charge.succesful?
        @user.stripe_customer_id = charge.customer_id
        @user.save
        handle_invitation
        flash[:success] = "Welcome, #{@user.name}! Your account has been created, please login below."
        UserMailer.delay.welcome(@user.id)

        redirect_to login_path
      else
        flash[:danger] = charge.error_message
        render 'new'
      end

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

  def handle_invitation
    if params[:invitation_token]
      invitation = Invitation.find_by(token: params[:invitation_token])

      @user.follow!(invitation.author)
      invitation.author.follow!(@user)
      invitation.clear_token!
    end
  end
end
