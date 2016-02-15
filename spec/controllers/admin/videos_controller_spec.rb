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

  describe 'POST #create' do
    it_behaves_like "requires admin" do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end

    context 'as admin user' do
      before do
        set_current_admin
      end

      context 'valid input' do
        let(:video_attributes) { Fabricate.attributes_for(:video) }

        it 'saves the Video' do
          post :create, video: video_attributes

          expect(Video.count).to eq 1
        end

        it 'redirects to the admin_path' do
          post :create, video: video_attributes

          expect(response).to redirect_to admin_path
        end

        it 'sets the flash message' do
          post :create, video: video_attributes

          expect(flash[:success]).to be_present
        end

        it 'doesnt upload the large cover' do
          post :create, video: video_attributes

          expect(Video.first.large_cover).not_to be_present

        end

        it 'doesnt upload the small cover' do
          post :create, video: video_attributes

          expect(Video.first.small_cover).not_to be_present
        end

        context 'with covers' do
          let(:video_attributes) { Fabricate.attributes_for(:video_with_covers) }

          it 'uploads the large cover' do
            post :create, video: video_attributes

            expect(Video.first.large_cover).to be_present
          end

          it 'uploads the small cover' do
            post :create, video: video_attributes

            expect(Video.first.small_cover).to be_present
          end

        end
      end

      context 'invalid input' do
        let(:video_attributes) { Fabricate.attributes_for(:video, title: nil) }

        it 'doesnt save the Video' do
          post :create, video: video_attributes

          expect(Video.count).to eq 0
        end

        it 'renders the new template' do
          post :create, video: video_attributes

          expect(response).to render_template 'new'
        end

        it 'sets the @video variable' do
          post :create, video: video_attributes

          expect(assigns(:video)).to be_present
        end
      end
    end


  end
end
