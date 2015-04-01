require "spec_helper"

describe SessionsController do
  let(:user) { User.create( name: 'John Doe', email: 'johndoe@example.com', password: 'secret' ) }

  describe "POST #create" do
    it "fails authentication for unknown e-mail address" do
      post :create, { email: 'bla@example.com', password: user.password }

      expect(session['user_id']).to be_nil
      expect(response).to render_template :new
    end

    it "fails authentication for the incorrect password" do
      post :create, { email: user.email, password: 'johndoe' }

      expect(session['user_id']).to be_nil
      expect(response).to render_template :new
    end

    it "authenticates and logs in the user" do
      post :create, { email: user.email, password: user.password }

      expect(session['user_id']).to eq(user.id)
      expect(response).to redirect_to(home_path)
    end
  end

  describe "DELETE #destroy" do
    it "should remove the user_id from the session" do
      request.session[:user_id] = user.id

      delete :destroy

      expect(session['user_id']).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end