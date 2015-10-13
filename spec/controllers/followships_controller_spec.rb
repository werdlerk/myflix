require "spec_helper"

describe FollowshipsController do
  let(:user) { Fabricate(:user) }
  let(:follower) { Fabricate(:user) }

  describe 'GET #index' do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it "should set the @followships variable" do
        get :index

        expect(assigns(:followships)).to eq([])
      end

      it 'should render the index template' do
        get :index

        expect(response).to render_template 'index'
      end

    end
  end

  describe 'POST #create' do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, follower_id: 1 }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it 'creates the Followship' do
        post :create, follower_id: follower.id

        expect(Followship.count).to eq 1
      end

      it 'redirects to the people page' do
        post :create, follower_id: follower.id

        expect(response).to redirect_to people_path
      end

      it 'shows a flash message' do
        post :create, follower_id: follower.id

        expect(flash[:success]).to be_present
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the user cant be found' do
        expect {
          post :create, follower_id: 99
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  describe 'DELETE #destroy' do
    let(:followship) { Fabricate(:followship, user: user, follower: follower) }
    let(:followship2) { Fabricate(:followship, user: follower, follower: follower) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it 'removes the Followship' do
        delete :destroy, id: followship.id

        expect(Followship.count).to eq 0
      end

      it 'redirects to the people page' do
        delete :destroy, id: followship.id

        expect(response).to redirect_to people_path
      end

      it 'sets a flash message' do
        delete :destroy, id: followship.id

        expect(flash[:success]).to be_present
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the followship isnt owned by the user' do
        expect {
          delete :destroy, id: followship2.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the followship cant be found' do
        expect {
          delete :destroy, id: 99
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end