class CreatePayment

  def call(event)
    charge = event.data.object
    user = User.find_by(stripe_customer_id: charge.customer)
    Payment.create(amount_cents: charge.amount, user: user, reference: charge.id) if user
  end

end
