require 'spec_helper'

describe ReviewsController do

  describe 'POST #create' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    context 'authenticated users' do

      before { request.session[:user_id] = user.id }

      context 'with valid input' do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'should create the new Review' do
          expect(assigns(:review)).not_to be_a_new(Review)
        end

        it 'sets the flash message' do
          expect(flash[:success]).to be_present
        end

        it 'redirects to the video show page' do
          expect(response).to redirect_to video_path(video)
        end
      end

      context 'with invalid input' do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, text: nil)
        end

        it 'does not create the Review' do
          expect(assigns(:review)).to be_a_new(Review)
        end

        it 'renders the videos/show template' do
          expect(response).to render_template 'videos/show'
        end
      end
    end

    context 'unauthenticated users' do
      it 'redirects to the root path' do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)

        expect(response).to redirect_to root_path
      end
    end
  end

end