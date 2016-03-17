module StripeWrapper

  DEFAULT_CURRENCY = "usd"

  class Charge
    def initialize(status, responses = {})
      @status = status
      @customer = responses[:customer]
      @charge = responses[:charge]
      @error = responses[:error]
    end

    def self.create(options = {})
      begin
        customer = Stripe::Customer.create(
          source: options[:token],
          description: options[:customer]
        )

        charge = Stripe::Charge.create(
          amount: options[:amount],
          currency: options[:currency] || DEFAULT_CURRENCY,
          customer: customer.id,
          description: options[:description]
        )
        new(:success, customer: customer, charge: charge)

      rescue Stripe::CardError => e
        new(:error, error: e)
      end
    end

    def succesful?
      @status == :success
    end

    def error_message
      @error.message unless succesful?
    end

    def customer_id
      @customer.id if succesful?
    end
  end

end
