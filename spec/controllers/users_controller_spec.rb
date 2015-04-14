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
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'should create the user' do
        expect(assigns(:user)).not_to be_a_new(User)
        expect(User.count).to eq(1)
      end

      it 'should redirect to the login page with the flash message' do
        expect(response).to redirect_to login_path
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

end