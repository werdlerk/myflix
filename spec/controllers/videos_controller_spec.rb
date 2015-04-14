require 'spec_helper'

describe VideosController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }

  describe 'GET #index' do
    it 'sets the @categories variable for authenticated users' do
      request.session['user_id'] = user.id

      local_video = video

      get :index
      expect(assigns(:categories)).to eq([local_video.category])
    end

    it 'redirects to root path for unauthenticated users' do
      local_video = video

      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #show' do
    context 'authenticated users' do
      before { request.session['user_id'] = user.id }
      it 'sets the @video variable for authenticated users' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it 'sets the @review variable for authenticated users' do
        get :show, id: video.id
        expect(assigns(:review)).to be_a_new(Review)
      end
    end

    context 'unauthenticated users' do
      it 'redirects to root for unauthenticated users' do
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #search' do
    it 'sets the @videos variable for authenticated users' do
      request.session['user_id'] = user.id
      mary_poppins = Fabricate(:video, title: 'Mary Poppins')

      post :search, q:'oppin'
      expect(assigns(:videos)).to eq([mary_poppins])
    end

    it 'redirects to root_path for unauthenticated users' do
      post :search, q: 'Mary'
      expect(response).to redirect_to root_path
    end
  end

end