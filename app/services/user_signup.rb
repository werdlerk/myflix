class UserSignup
  attr_reader :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(options = {})
    stripe_token = options[:stripe_token]
    invitation_token = options[:invitation_token]
    if @user.valid?
      charge = StripeWrapper::Charge.create(token: stripe_token, customer: @user.name, amount: 999, description: "MyFLiX Signup fee for #{@user.email}")

      if charge.succesful?
        @user.stripe_customer_id = charge.customer_id
        @user.save
        handle_invitation(invitation_token)

        UserMailer.delay.welcome(@user.id)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "There was an error creating your account. Please check the errors below."
      self
    end
  end

  def succesful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)

      @user.follow!(invitation.author)
      invitation.author.follow!(@user)
      invitation.clear_token!
    end
  end
end
