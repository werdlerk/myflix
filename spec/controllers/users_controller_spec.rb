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
      it 'should create the user' do
        post :create, user: Fabricate.attributes_for(:user)

        expect(assigns(:user)).to be_persisted
        expect(User.count).to eq(1)
      end

      it 'should redirect to the login page with the flash message' do
        post :create, user: Fabricate.attributes_for(:user)

        expect(response).to redirect_to login_path
      end

      context 'send welcome email' do
        before do
          post :create, user: Fabricate.attributes_for(:user)
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

        before do
          post :create, user: { email: 'john@example.com', password:'Password!', name: 'John Hope'}, invitation_token: invitation.token
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

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET #new_with_invitation' do
    let(:invitation) { Fabricate(:invitation) }

    it 'sets the @user with recipient\'s email' do
      get :new_with_invitation, token: invitation.token

      expect(assigns(:user)).to be_a_new User
      expect(assigns(:user).name).to eq invitation.name
      expect(assigns(:user).email).to eq invitation.email
    end

    it 'renders to expired token page for invalid tokens' do
      get :new_with_invitation, token: "123"

      expect(response).to redirect_to invalid_token_path
    end

    it 'renders the new template' do
      get :new_with_invitation, token: invitation.token

      expect(response).to render_template 'new'
    end

    it 'sets the @invitation variable' do
      get :new_with_invitation, token: invitation.token

      expect(assigns(:invitation)).to eq invitation
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
