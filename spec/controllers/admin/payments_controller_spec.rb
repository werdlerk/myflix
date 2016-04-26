require 'spec_helper'

describe Admin::PaymentsController do

  describe 'GET #index' do
    it_behaves_like "requires admin" do
      let(:action) { get :index }
    end

    context 'admin users' do
      let(:user) { Fabricate(:user) }
      let!(:payment) { Fabricate(:payment, user: user) }

      before do
        set_current_admin

        get :index
      end

      it 'renders the template' do
        expect(response).to render_template 'index'
      end

      it 'sets the @payments variable' do
        expect(assigns(:payments)).to eq [ payment ]
      end
    end
  end

end
