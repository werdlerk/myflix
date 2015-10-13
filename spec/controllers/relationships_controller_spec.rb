require "spec_helper"

describe RelationshipsController do
  let(:user) { Fabricate(:user) }
  let(:follower) { Fabricate(:user) }

  describe 'GET #index' do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it "should set the @relationships variable" do
        get :index

        expect(assigns(:relationships)).to eq([])
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

      it 'creates the Relationship' do
        post :create, follower_id: follower.id

        expect(Relationship.count).to eq 1
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
    let(:relationship) { Fabricate(:relationship, user: user, follower: follower) }
    let(:relationship2) { Fabricate(:relationship, user: follower, follower: follower) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it 'removes the Relationship' do
        delete :destroy, id: relationship.id

        expect(Relationship.count).to eq 0
      end

      it 'redirects to the people page' do
        delete :destroy, id: relationship.id

        expect(response).to redirect_to people_path
      end

      it 'sets a flash message' do
        delete :destroy, id: relationship.id

        expect(flash[:success]).to be_present
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the relationship isnt owned by the user' do
        expect {
          delete :destroy, id: relationship2.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the relationship cant be found' do
        expect {
          delete :destroy, id: 99
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end