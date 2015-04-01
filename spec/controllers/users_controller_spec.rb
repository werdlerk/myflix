require "spec_helper"

describe UsersController do
  
  describe 'GET #new' do
    it 'should render the new template' do
      get :new

      expect(response).to render_template :new
    end

    it 'should create the @user variable' do
      get :new

      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    let(:user_params) { { user: { name: 'Koen', :email => 'koen@example.com', :password => 'is a secret' } } }
    it 'should create the user' do
      post :create, user_params

      expect(assigns(:user)).not_to be_a_new(User)
    end

    it 'should redirect to the login page with the flash message' do
      post :create, user_params

      expect(response).to redirect_to login_path
    end

    it 'should render the new page for form errors' do
      post :create, { user: { name: 'Koen' } }

      expect(response).to render_template 'new'
    end
  end

end