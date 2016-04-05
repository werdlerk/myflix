require 'spec_helper'

describe 'Stripe Events' do

  def stub_event(event_id, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event_id}").
      to_return(status: status, body: File.read("spec/support/fixtures/#{event_id}.json"))
  end

  describe 'charge.succeeded' do
    before do
      stub_event 'charge.succeeded'
    end

    it 'is successful' do
      post '/_stripe_events', id: 'charge.succeeded'

      expect(response.code).to eq '200'
    end

    context 'with an existing user matching the customer id' do
      let!(:user) { Fabricate(:user, stripe_customer_id: 'cus_8BZ10L35ILqiBH') }

      before do
        post '/_stripe_events', id: 'charge.succeeded'
      end

      it 'creates a Payment' do
        expect(Payment.count).to eq 1
      end

      it 'sets the amount cents on the Payment' do
        expect(Payment.last.amount_cents).to eq 999
      end

      it 'sets the stripe charge id as the reference' do
        expect(Payment.last.reference_id).to eq 'ch_17vBtuFdcisUpWXbVrJHFIEf'
      end
    end

    context 'without an existing user with the customer id' do

      it 'doesnt create a Payment' do
        post '/_stripe_events', id: 'charge.succeeded'

        expect(Payment.count).to eq 0
      end
    end


  end

end
