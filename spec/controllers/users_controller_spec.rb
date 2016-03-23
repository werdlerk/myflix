require "spec_helper"

describe UsersController do

  describe 'GET #new' do
    before do
      get :new
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end

    it 'sets the @user variable' do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do

    before do
      expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(user_signup)
    end

    context "successful user sign up" do
      let(:user_signup) { double(UserSignup, succesful?: true) }

      it 'redirects to the login page' do
        post :create, user: Fabricate.attributes_for(:user)

        expect(response).to redirect_to login_path
      end

      it 'sets the flash message' do
        post :create, user: Fabricate.attributes_for(:user)

        expect(flash[:success]).to be_present
      end
    end

    context "failed user sign up" do
      let(:user_signup) { double(UserSignup, succesful?: false, error_message: 'Something went wrong') }

      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'renders the new page for form errors' do
        expect(response).to render_template 'new'
      end

      it 'sets the @user variable' do
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'sets the flash message' do
        expect(flash[:danger]).to eq 'Something went wrong'
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
      set_current_user
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

end
