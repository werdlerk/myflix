require 'spec_helper'

describe UserSignup do

  describe '#sign_up' do
    let(:stripe_charge) { double(Stripe::Charge) }
    let(:service) { UserSignup.new(user) }

    before do
      allow(StripeWrapper::Charge).to receive(:create).and_return stripe_charge
      allow(stripe_charge).to receive_messages(succesful?: true, customer_id: "ABC123")
    end

    context 'with valid input' do
      let(:user) { Fabricate.build(:user) }

      it 'sets the status to success' do
        service.sign_up

        expect(service.status).to eq :success
      end

      it 'has no error message' do
        service.sign_up

        expect(service.error_message).to be_nil
      end

      it 'creates the user' do
        service.sign_up

        expect(user).to be_persisted
        expect(User.count).to eq(1)
      end

      context 'send welcome email' do
        before do
          service.sign_up
        end

        it 'sends an email' do
          expect(ActionMailer::Base.deliveries.count).to eq 1
        end

        it 'sends to the right recipient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq [ User.first.email ]
        end

        it "has the right content" do
          email = ActionMailer::Base.deliveries.last
          expect(email.body.encoded).to include User.first.name
        end
      end

      context 'with invitation' do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, author: inviter) }
        let(:user) { Fabricate.build(:user, email: 'john@example.com', password:'Password!', name: 'John Hope') }

        before do
          service.sign_up(invitation_token: invitation.token)
        end

        it 'makes the user follow the inviter' do
          john = User.find_by(email: 'john@example.com')
          expect(john.follows?(inviter)).to eq true
        end

        it 'makes the inviter follow the user' do
          john = User.find_by(email: 'john@example.com')
          expect(inviter.follows?(john)).to eq true
        end

        it 'expires the invitation upon access' do
          expect(Invitation.first.token).to be_nil
        end
      end
    end

    context 'with invalid input' do
      let(:user) { Fabricate.build(:user, password: nil) }

      it 'sets the status to failed' do
        service.sign_up

        expect(service.status).to eq :failed
      end

      it 'sets the error message' do
        service.sign_up

        expect(service.error_message).to be_present
      end

      it 'does not create the user' do
        service.sign_up

        expect(User.count).to eq(0)
      end

      it 'does not send an email' do
        service.sign_up

        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'does not charge using Stripe' do
        expect(StripeWrapper::Charge).not_to receive(:create)

        service.sign_up
      end
    end

    context 'with failed Stripe::Charge' do
      let(:user) { Fabricate.build(:user) }

      before do
        allow(stripe_charge).to receive_messages(succesful?: false, error_message: 'Something went wrong :-(')

        service.sign_up
      end

      it 'does not create the user' do
        expect(User.count).to eq(0)
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the error message' do
        expect(service.error_message).to eq 'Something went wrong :-('
      end
    end
  end

end
