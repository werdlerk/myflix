module StripeWrapper

  DEFAULT_PLAN = "base"
  DEFAULT_CURRENCY = "usd"

  class Customer
    def initialize(status, responses = {})
      @status = status
      @customer = responses[:customer]
      @error = responses[:error]
    end

    def self.create(options = {})
      begin
        customer = Stripe::Customer.create(
          source: options[:token],
          description: options[:customer],
          email: options[:email],
          plan: options[:plan] || DEFAULT_PLAN
        )
        new(:success, customer: customer)

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

    def id
      @customer.id if succesful?
    end
  end

  class Charge
    def initialize(status, responses = {})
      @status = status
      @charge = responses[:charge]
      @error = responses[:error]
    end

    def self.create(options = {})
      begin
        charge = Stripe::Charge.create(
          amount: options[:amount],
          currency: options[:currency] || DEFAULT_CURRENCY,
          customer: options[:customer_id],
          description: options[:description]
        )
        new(:success, charge: charge)

      rescue Stripe::InvalidRequestError => e
        new(:error, error: e)
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
  end

end
