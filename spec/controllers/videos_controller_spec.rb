require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }

  describe 'GET #index' do
    it 'sets the @categories variable for authenticated users' do
      set_current_user

      local_video = video

      get :index
      expect(assigns(:categories)).to eq([local_video.category])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe 'GET #show' do
    context 'authenticated users' do
      let!(:review) { Fabricate(:review, video: video) }

      before do
        set_current_user
        get :show, id: video.id
      end

      it 'sets the @video to the VideoDecorator' do
        expect(assigns(:video)).to be_decorated_with VideoDecorator
      end

      it 'sets the @reviews variable' do
        expect(assigns(:reviews)).to match_array Review.all
      end

      it 'sets the @review variable' do
        expect(assigns(:review)).to be_a_new(Review)
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'POST #search' do
    context 'authenticated users' do
      before { set_current_user }

      it 'sets the @videos variable' do
        mary_poppins = Fabricate(:video, title: 'Mary Poppins')

        post :search, q:'oppin'
        expect(assigns(:videos)).to eq([mary_poppins])
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, q: 'Mary' }
    end
  end

end
