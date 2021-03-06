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
      Fabricate(:user, stripe_customer_id: 'cus_8BZ10L35ILqiBH')

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

      it 'associates the user with the Payment' do
        expect(Payment.last.user).to eq user
      end

      it 'sets the amount cents on the Payment' do
        expect(Payment.last.amount_cents).to eq 999
      end

      it 'sets the stripe charge id as the reference' do
        expect(Payment.last.reference_id).to eq 'ch_17vBtuFdcisUpWXbVrJHFIEf'
      end
    end

    context 'without an existing user with the customer id' do

      it 'raises an error' do
        expect {
          post '/_stripe_events', id: 'charge.succeeded'
          }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'charge.failed' do

    context 'without a customer id' do

      it 'sends no e-mail' do
        stub_event 'charge.failed_without_customer'

        post '/_stripe_events', id: 'charge.failed_without_customer'

        expect(ActionMailer::Base.deliveries).to be_empty
      end

    end

    context 'with a customer id' do
      let!(:user) { Fabricate(:user, stripe_customer_id: 'cus_8BZ10L35ILqiBH') }

      before do
        stub_event 'charge.failed'

        post '/_stripe_events', id: 'charge.failed'
      end

      it 'deactivates the user' do
        expect(user.reload).not_to be_active
      end

      it 'sends an email about the failed charge' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end


  end

end
