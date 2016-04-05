class CreatePayment

  def call(event)
    user = User.find_by(stripe_customer_id: event.data.object.customer)
    Payment.create(amount_cents: event.data.object.amount, user: user) if user
  end

end
