require "spec_helper"

describe UsersController do

  describe 'GET #new' do
    before do
      get :new
    end

    it 'should render the new template' do
      expect(response).to render_template :new
    end

    it 'should sets the @user variable' do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do

    context "with valid input" do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'should create the user' do
        expect(assigns(:user)).to be_persisted
        expect(User.count).to eq(1)
      end

      it 'should redirect to the login page with the flash message' do
        expect(response).to redirect_to login_path
      end

      context 'send welcome email' do
        it 'sends an email' do
          expect(ActionMailer::Base.deliveries.count).to eq 1
        end

        it 'sends to the right recipient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq [ User.first.email ]
        end

        it "has the right content" do
          email = ActionMailer::Base.deliveries.last
          expect(email.body.encoded).to include "Your account has been succesfully created"
        end
      end

    end

    context "with invalid input" do
      before do
        post :create, { user: { name: 'Koen' } }
      end

      it 'does not create the user' do
        expect(User.count).to eq(0)
      end

      it 'should render the new page for form errors' do
        expect(response).to render_template 'new'
      end

      it 'sets the @user variable' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe "GET #show" do
    let(:user) { Fabricate(:user) }

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: user.id }
    end

    it "should set the @user variable" do
      sign_in
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

end