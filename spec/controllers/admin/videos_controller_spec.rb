require "spec_helper"

describe Admin::VideosController do
  describe 'GET #new' do
    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    context 'admin users' do
      before do
        set_current_admin

        get :new
      end

      it 'renders the template' do
        expect(response).to render_template 'new'
      end

      it 'sets the @video variable' do
        expect(assigns(:video)).to be_a_new Video
      end
    end


  end
end
