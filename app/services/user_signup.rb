class UserSignup
  attr_reader :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(options = {})
    stripe_token = options[:stripe_token]
    invitation_token = options[:invitation_token]

    if @user.valid?
      customer = StripeWrapper::Customer.create(token: stripe_token, customer: @user.name, email: @user.email)

      if customer.succesful?
        @user.stripe_customer_id = customer.id
        @user.save
        handle_invitation(invitation_token) if invitation_token.present?

        UserMailer.delay.welcome(@user.id)
      else
        @error_message = customer.error_message
      end
    else
      @error_message = "There was an error creating your account. Please check the errors below."
    end

    @status = @error_message.present? ? :failed : :success
    self
  end

  def succesful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by(token: invitation_token)

    @user.follow!(invitation.author)
    invitation.author.follow!(@user)
    invitation.clear_token!
  end
end
