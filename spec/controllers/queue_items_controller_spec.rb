require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

  describe 'GET #index' do

    context 'authenticated users' do
      before { request.session[:user_id] = user.id }

      it 'sets the @queue_items variable to the queue items of the logged in user' do
        Fabricate(:queue_item, video:video, user:User.create(name:'second', email:'second@example.com', password:'secondsecond'))

        get :index

        expect(assigns(:queue_items)).to match_array([queue_item])
      end

      it 'renders the index template' do
        get :index

        expect(response).to render_template :index
      end

    end

    context 'unauthenticated users' do
      it 'sets the flash message' do
        get :index

        expect(flash[:warning]).to be_present
      end

      it 'redirects to root_path' do
        get :index

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create' do

    context 'authenticated users' do
      before { request.session[:user_id] = user.id }

      it 'creates the QueueItem' do
        post :create, video_id: video.id

        expect(QueueItem.count).to eq(1)
      end

      it 'redirects to queue_items_path' do
        post :create, video_id: video.id

        expect(response).to redirect_to my_queue_path
      end

      it 'creates the queue item that is associated with the video' do
        post :create, video_id: video.id

        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates the queue item that is associated with the current_user' do
        post :create, video_id: video.id

        expect(QueueItem.first.user).to eq(user)
      end

      it 'puts the video as the last one in the queue' do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)

        post :create, video_id: video2.id
        post :create, video_id: video1.id

        last_queue_item = QueueItem.where(video_id: video1.id, user: user).first

        expect(last_queue_item.order).to eq(2)
      end

      it 'does not add the queue_item if the video is already in a queue_item' do
        post :create, video_id: video.id
        post :create, video_id: video.id

        expect(QueueItem.count).to eq(1)
      end
    end

    context 'unauthenticated users' do
      it 'redirects to the root_path for unauthenticated users' do
        post :create, video_id: video.id

        expect(response).to redirect_to root_path
      end

      it 'sets the flash message' do
        post :create, video_id: video.id

        expect(flash[:warning]).to be_present
      end
    end

  end

  describe 'DELETE #destroy' do

    context 'authenticated users' do
      before { request.session['user_id'] = user.id }

      it 'destroys the queue_item' do
        delete :destroy, id: queue_item.id

        expect(QueueItem.count).to eq(0)
      end

      it 'redirects to the queue_items_path' do
        delete :destroy, id: queue_item.id

        expect(response).to redirect_to queue_items_path
      end

      it 'updates the order of the other queue_items' do
        queue_item1 = Fabricate(:queue_item, video: video, user: user)

        video2 = Fabricate(:video)
        queue_item2 = Fabricate(:queue_item, video: video2, user: user)

        video3 = Fabricate(:video)
        queue_item3 = Fabricate(:queue_item, video: video3, user: user)

        delete :destroy, id: queue_item1.id

        expect(queue_item3.reload.order).to eq(2)
      end
    end

    context 'unauthenticated users' do

      it 'redirects to the root_path for unauthenticated users' do
        delete :destroy, id: queue_item.id

        expect(response).to redirect_to root_path
      end

      it 'sets the flash message' do
        delete :destroy, id: queue_item.id

        expect(flash[:warning]).to be_present
      end
    end
  end

end