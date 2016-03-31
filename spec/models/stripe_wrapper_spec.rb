require 'spec_helper'

describe StripeWrapper, :vcr do
  let(:stripe_token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 3,
        :exp_year => Date.today.year + 1,
        :cvc => "314"
      }
    )
  end

  describe StripeWrapper::Customer do
    let(:customer) { StripeWrapper::Customer.create(token: stripe_token.id, customer: "Klaas Vaak") }

    describe '.create' do
      context 'with valid card' do
        let(:card_number) { '4242424242424242'}

        it 'creates the customer succesfully' do
          expect(customer).to be_succesful
        end

        it 'has no error message' do
          expect(customer.error_message).to be_nil
        end

        it 'has a customer id' do
          expect(customer.id).to be_present
        end
      end

      context 'with invalid card' do
        let(:card_number) { '4000000000000002'}

        it 'does not creates the customer succesfully' do
          expect(customer).not_to be_succesful
        end

        it 'contains an error message' do
          expect(customer.error_message).to eq "Your card was declined."
        end

        it 'has no customer id' do
          expect(customer.id).to be_nil
        end
      end
    end
  end

  describe StripeWrapper::Charge do
    let(:card_number) { '4242424242424242'}
    let(:customer) { StripeWrapper::Customer.create(token: stripe_token.id, customer: "Klaas Vaak")}

    describe '.create' do
      context 'with valid options' do
        let(:charge) { StripeWrapper::Charge.create(customer_id: customer.id, description: "signup fee", amount: 300) }

        it 'charges the card succesfully' do
          expect(charge).to be_succesful
        end

        it 'has no error message' do
          expect(charge.error_message).to be_nil
        end
      end

      context 'with invalid options' do
        let(:charge) { StripeWrapper::Charge.create(customer_id: customer.id, description: "signup fee", amount: 0) }

        it 'does not charge the card succesfully' do
          expect(charge).not_to be_succesful
        end

        it 'contains an error message' do
          expect(charge.error_message).to eq "Invalid positive integer"
        end
      end
    end
  end

end
