require "spec_helper"

describe SessionsController do
  let(:user) { User.create( name: 'John Doe', email: 'johndoe@example.com', password: 'secret' ) }

  describe "GET #new" do
    it "renders the new template for unauthenticated users" do
      get :new

      expect(response).to render_template :new
    end

    it "redirects to the home page for authenticated users" do
      request.session[:user_id] = user.id

      get :new

      expect(response).to redirect_to home_path
    end
  end

  describe "POST #create" do
    context "with invalid credentials" do
      before do
        post :create,  { email: user.email, password: 'john' }
      end

      it "does not set the user id in the session" do
        expect(session['user_id']).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the error message" do
        expect(flash[:danger]).to be_present
      end
    end

    context 'with a deactivated user' do
      before do
        user.deactivate!

        post :create, { email: user.email, password: user.password }
      end

      it "does not set the user id in the session" do
        expect(session['user_id']).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the error message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with valid credentials" do
      before do
        post :create, { email: user.email, password: user.password }
      end

      it "sets the user id in the session" do
        expect(session['user_id']).to eq(user.id)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to(home_path)
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end

      context "as admin" do
        let(:user) { Fabricate(:admin) }

        it 'redirects to the admin page' do
          expect(response).to redirect_to(admin_path)
        end
      end
    end

  end

  describe "GET #destroy" do
    before do
      request.session[:user_id] = user.id
      get :destroy
    end

    it "clears the session id for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the success notice" do
      expect(flash[:success]).to be_present
    end
  end
end
