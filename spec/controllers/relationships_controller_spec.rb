require "spec_helper"

describe RelationshipsController do
  let(:user) { Fabricate(:user) }
  let(:john) { Fabricate(:user) }

  describe 'GET #index' do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it "should set empty @relationships variable when there are no relationships" do
        get :index

        expect(assigns(:relationships)).to eq([])
      end

      it 'should set @relationships variable to the following relationships' do
        relationship = Fabricate(:relationship, leader: john, follower: user)

        get :index

        expect(assigns(:relationships)).to eq [ relationship ]
      end

      it 'should render the index template' do
        get :index

        expect(response).to render_template 'index'
      end

    end
  end

  describe 'POST #create' do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    context 'authenticated users' do
      before { sign_in(user) }

      it 'creates the Relationship' do
        post :create, leader_id: john.id

        expect(Relationship.count).to eq 1
      end

      it 'redirects to the people page' do
        post :create, leader_id: john.id

        expect(response).to redirect_to people_path
      end

      it 'shows a flash message' do
        post :create, leader_id: john.id

        expect(flash[:success]).to be_present
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the user cant be found' do
        expect {
          post :create, leader_id: 99
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  describe 'DELETE #destroy' do
    let(:relationship) { Fabricate(:relationship, leader: john, follower: user) }
    let(:relationship2) { Fabricate(:relationship, leader: john, follower: john) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: relationship.id }
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

      it 'throws an ActiveRecord::RecordNotFound exception when the user isnt the follower in the given relationship' do
        expect {
          delete :destroy, id: relationship2.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'throws an ActiveRecord::RecordNotFound exception when the relationship cant be found' do
        expect {
          delete :destroy, id: relationship2.id + 10
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end