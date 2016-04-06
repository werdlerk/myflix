class FailedPayment

  def call(event)
    charge = event.data.object
    user = User.find_by(stripe_customer_id: charge.customer)

    if user
      user.update_attributes(blocked: true)
      UserMailer.delay.payment_failed(user.id)
    end
  end

end
