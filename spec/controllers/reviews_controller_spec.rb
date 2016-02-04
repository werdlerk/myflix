require 'spec_helper'

describe ReviewsController do

  describe 'POST #create' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    context 'authenticated users' do

      before { set_current_user(user) }

      context 'with valid input' do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'should create the new Review' do
          expect(Review.count).to eq(1)
        end

        it 'should create the Review associated with the video' do
          expect(Review.first.video).to eq video
        end

        it 'should create the Review associated with the signed in user' do
          expect(Review.first.author).to eq user
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
          expect(Review.count).to eq(0)
        end

        it 'sets @video variable for the current video' do
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews variable for displaying current reviews' do
          expect(assigns(:reviews)).to eq(video.reviews)
        end

        it 'renders the videos/show template' do
          expect(response).to render_template 'videos/show'
        end

        it 'sets the validation message' do
          expect(assigns(:review).errors).to be_present
        end
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: video.id, review: Fabricate.attributes_for(:review) }
    end
  end

end
