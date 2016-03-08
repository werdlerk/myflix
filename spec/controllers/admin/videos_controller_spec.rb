require "spec_helper"

describe Admin::VideosController do
  describe 'GET #new' do
    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    context 'admin users' do
      let!(:category) { Fabricate(:category) }

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

      it 'sets the Categories in the @categories variable' do
        expect(assigns(:categories)).to be_present
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like "requires admin" do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end

    context 'as admin user' do
      let!(:category) { Fabricate(:category) }

      before do
        set_current_admin
      end

      context 'with valid input' do
        let(:video_attributes) { Fabricate.attributes_for(:video) }

        before do
          post :create, video: video_attributes
        end

        it 'saves the Video' do
          expect(Video.count).to eq 1
        end

        it 'redirects to the admin_path' do
          expect(response).to redirect_to admin_path
        end

        it 'sets the flash message' do
          expect(flash[:success]).to be_present
        end

        it 'doesnt upload the large cover' do
          expect(Video.first.large_cover).not_to be_present

        end

        it 'doesnt upload the small cover' do
          expect(Video.first.small_cover).not_to be_present
        end

        context 'with covers' do
          let(:video_attributes) { Fabricate.attributes_for(:video_with_covers) }

          before do
            post :create, video: video_attributes
          end

          it 'uploads the large cover' do
            expect(Video.first.large_cover).to be_present
          end

          it 'uploads the small cover' do
            expect(Video.first.small_cover).to be_present
          end
        end
      end

      context 'with invalid input' do
        let(:video_attributes) { Fabricate.attributes_for(:video, title: nil) }

        before do
          post :create, video: video_attributes
        end

        it 'doesnt save the Video' do
          expect(Video.count).to eq 0
        end

        it 'renders the new template' do
          expect(response).to render_template 'new'
        end

        it 'sets the @video variable' do
          expect(assigns(:video)).to be_present
        end

        it 'sets the Categories in the @categories variable' do
          expect(assigns(:categories)).to be_present
        end
      end
    end


  end
end
