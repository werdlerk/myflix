require "spec_helper"

describe PasswordsController do

  describe 'GET #new' do
    it 'redirects logged in users to the home page' do
      sign_in

      get :new

      expect(response).to redirect_to home_path
    end

    it 'renders the new template' do
      get :new

      expect(response).to render_template 'new'
    end
  end

  describe 'POST #create' do
    let(:user) { Fabricate(:user) }

    context 'with valid input' do
      it 'sends a reset password email' do
        post :create, email: user.email

        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it 'shows the reset password confirmation page' do
        post :create, email: user.email

        expect(response).to render_template 'create'
      end
    end

    context 'with empty input' do
      before { post :create, email: '' }

      it 'does not send a reset password email if no email is given' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders the new template' do
        expect(response).to render_template 'new'
      end

      it 'shows the flash error message' do
        expect(flash[:warning]).to be_present
      end

    end

    context 'with invalid input' do
      it 'does not send a reset password email if the email is invalid' do
        post :create, email: 'bla'

        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'does not send a reset password email if the email doesnt exist' do
        post :create, email: "#{user.email}bla"

        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders the new template' do
        post :create, email: 'bla'

        expect(response).to render_template 'new'
      end

      it 'shows the flash error message' do
        post :create, email: 'bla'

        expect(flash[:warning]).to be_present
      end
    end
  end

  describe 'GET #edit' do
    it 'redirects logged in users to the home page' do
      sign_in

      get :edit

      expect(response).to redirect_to home_path
    end

    context 'valid token' do
      let(:user) { Fabricate(:user, token: SecureRandom.urlsafe_base64, token_expiration: 1.hour.from_now) }

      it 'renders the edit template' do
        get :edit, token: user.token

        expect(response).to render_template 'edit'
      end

    end

    context 'invalid token' do
      let(:user) { Fabricate(:user, token: SecureRandom.urlsafe_base64, token_expiration: DateTime.now) }

      it 'redirects to invalid_token_path for an expired token' do
        get :edit, token: user.token

        expect(response).to redirect_to invalid_token_path
      end

      it 'redirects to invalid_token_path for a bad token' do
        get :edit, token: 'bla'

        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe 'PUT #update' do

    it 'redirects logged in users to the home page' do
      sign_in

      put :update

      expect(response).to redirect_to home_path
    end

    context 'valid token' do
      let(:user) { Fabricate(:user, token: SecureRandom.urlsafe_base64, token_expiration: 1.hour.from_now) }

      before do
        put :update, token: user.token, password: Faker::Internet.password
      end

      it 'changes the password' do
        expect(user.password_digest.to_s).not_to eq user.reload.password_digest
      end

      it 'invalidates the token' do
        expect(user.reload.token).to be_nil
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to login_path
      end

      it 'shows a flash confirmation message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'invalid token' do
      let!(:user) { Fabricate(:user, token: SecureRandom.urlsafe_base64, token_expiration: 1.hour.from_now) }

      before do
        put :update, token: 'slkdfj', password: Faker::Internet.password
      end

      it 'does not change the password' do
        expect(user.password_digest.to_s).to eq user.reload.password_digest
      end

      it 'redirects to the invalid_token_path' do
        expect(response).to redirect_to invalid_token_path
      end
    end

    context 'expired token' do
      let(:user) { Fabricate(:user, token: SecureRandom.urlsafe_base64, token_expiration: DateTime.now) }

      before do
        put :update, token: user.token, password: Faker::Internet.password
      end

      it 'does not change the password' do
        expect(user.password_digest.to_s).to eq user.reload.password_digest
      end

      it 'redirects to the invalid_token_path' do
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end
