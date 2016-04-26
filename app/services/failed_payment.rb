class FailedPayment

  def call(event)
    charge = event.data.object
    user = User.find_by(stripe_customer_id: charge.customer)

    if user
      user.deactivate!
      UserMailer.delay.payment_failed(user.id)
    end
  end

end
