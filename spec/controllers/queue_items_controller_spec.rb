require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

  describe 'GET #index' do

    context 'authenticated users' do
      before { request.session[:user_id] = user.id }

      it 'sets the @queue_items variable' do
        get :index

        expect(assigns(:queue_items).size).to eq(QueueItem.count)
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

  describe 'DELETE #destroy' do

    context 'authenticated users' do
      before { request.session['user_id'] = user.id }
      before do
        delete :destroy, id: queue_item.id
      end

      it 'destroys the queue_item' do
        expect(QueueItem.count).to eq(0)
      end

      it 'redirects to the queue_items_path' do
        expect(response).to redirect_to queue_items_path
      end

    end
  end

end