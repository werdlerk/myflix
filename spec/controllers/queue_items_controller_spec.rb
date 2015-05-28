require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

  describe 'GET #index' do

    context 'authenticated users' do
      before { sign_in user }

      it 'sets the @queue_items variable to the queue items of the logged in user' do
        other_user = Fabricate(:user, name:'second')
        other_queue_item = Fabricate(:queue_item, video:video, user:other_user)

        get :index

        expect(assigns(:queue_items)).to match_array([queue_item])
      end

      it 'renders the index template' do
        get :index

        expect(response).to render_template :index
      end

    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe 'POST #create' do

    context 'authenticated users' do
      before { sign_in(user) }

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

        expect(last_queue_item.position).to eq(2)
      end

      it 'does not add the queue_item if the video is already in a queue_item' do
        post :create, video_id: video.id
        post :create, video_id: video.id

        expect(QueueItem.count).to eq(1)
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: video.id }
    end

  end

  describe 'DELETE #destroy' do

    context 'authenticated users' do
      before { sign_in(user) }

      it 'destroys the queue_item' do
        delete :destroy, id: queue_item.id

        expect(QueueItem.count).to eq(0)
      end

      it 'redirects to the my_queue_path' do
        delete :destroy, id: queue_item.id

        expect(response).to redirect_to my_queue_path
      end

      it 'updates the position of the other queue_items' do
        queue_item1 = Fabricate(:queue_item, video: video, user: user)

        video2 = Fabricate(:video)
        queue_item2 = Fabricate(:queue_item, video: video2, user: user)

        video3 = Fabricate(:video)
        queue_item3 = Fabricate(:queue_item, video: video3, user: user)

        delete :destroy, id: queue_item1.id

        expect(queue_item2.reload.position).to eq(1)
        expect(queue_item3.reload.position).to eq(2)
      end

      it 'does not destroy the queue item of a different user' do
        user1 = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, video: video, user: user1)
        my_queue_item = Fabricate(:queue_item, video: video, user: user)

        expect {
          delete :destroy, id: queue_item1.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: queue_item.id }
    end
  end

  describe 'POST #change' do
    context 'authenticated users' do
      before { sign_in user }

      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, video: video1, user: user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: video2, user: user, position: 2) }

      context 'change positions' do
        context 'valid input' do
          it 'does not change the order when no changes are made' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1' },
              { 'id' => queue_item2.id.to_s, 'position' => '2' }
            ]

            expect(user.queue_items).to eq([queue_item1, queue_item2])
          end

          it 'changes the position of the item with a different position' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '3' },
              { 'id' => queue_item2.id.to_s, 'position' => '2' }
            ]

            expect(user.queue_items).to eq([queue_item2, queue_item1])
          end

          it 'normalizes the position numbers' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '3' },
              { 'id' => queue_item2.id.to_s, 'position' => '2' }
            ]

            expect(queue_item2.reload.position).to eq(1)
            expect(queue_item1.reload.position).to eq(2)
          end

          it 'redirects to the my_queue_path' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1' },
              { 'id' => queue_item2.id.to_s, 'position' => '2' }
            ]

            expect(response).to redirect_to my_queue_path
          end
        end

        context 'invalid input' do
          it 'does not change the order of queue_items of someone else' do
            other_user = Fabricate(:user, name:'second')
            other_queue_item1 = Fabricate(:queue_item, video:video1, user:other_user, position:1)
            other_queue_item2 = Fabricate(:queue_item, video:video2, user:other_user, position:2)

            post :change, 'queue_item' => [
              { 'id' => other_queue_item1.id.to_s, 'position' => '3' },
              { 'id' => other_queue_item2.id.to_s, 'position' => '4' }
            ]

            expect(other_queue_item1.reload.position).to eq(1)
            expect(other_queue_item2.reload.position).to eq(2)
          end

          it 'does not change the order when the position is not a number' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => 'a' },
              { 'id' => queue_item2.id.to_s, 'position' => 'b' }
            ]

            expect(queue_item1.reload.position).to eq(1)
            expect(queue_item2.reload.position).to eq(2)
          end

          it 'redirects to the my_queue_path' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1' },
              { 'id' => queue_item2.id.to_s, 'position' => '2' }
            ]

            expect(response).to redirect_to my_queue_path
          end
        end
      end

      context 'change ratings' do
        context 'valid input' do
          it 'does not change ratings when no changes are made' do
            review1 = Fabricate(:review, video: video1, author: user, rating: 1)
            review2 = Fabricate(:review, video: video2, author: user, rating: 2)

            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1', 'rating' => '1' },
              { 'id' => queue_item2.id.to_s, 'position' => '2', 'rating' => '2' }
            ]

            expect(review1.reload.rating).to eq(1)
            expect(review2.reload.rating).to eq(2)
          end

          it 'creates one review with the given rating' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1', 'rating' => '3' }
            ]

            expect(Review.count).to eq(1)
            expect(Review.first.rating).to eq(3)
          end

          it 'creates two reviews with the given ratings' do
            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1', 'rating' => '3' },
              { 'id' => queue_item2.id.to_s, 'position' => '2', 'rating' => '4' }
            ]

            expect(Review.count).to eq(2)
            expect(Review.second.rating).to eq(4)
          end

          it 'changes the rating of an existing review' do
            review1 = Fabricate(:review, video: video1, author: user, rating: 1)
            review2 = Fabricate(:review, video: video2, author: user, rating: 2)

            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1', 'rating' => '3' },
              { 'id' => queue_item2.id.to_s, 'position' => '2', 'rating' => '4' }
            ]

            expect(review1.reload.rating).to eq(3)
            expect(review2.reload.rating).to eq(4)
          end

          it 'redirects to my_queue_path' do
            review1 = Fabricate(:review, video: video1, author: user, rating: 1)
            review2 = Fabricate(:review, video: video2, author: user, rating: 2)

            post :change, 'queue_item' => [
              { 'id' => queue_item1.id.to_s, 'position' => '1', 'rating' => '1' },
              { 'id' => queue_item2.id.to_s, 'position' => '2', 'rating' => '2' }
            ]

            expect(response).to redirect_to my_queue_path
          end
        end

        context 'invalid input' do
          it 'does not create the review for someone else' do
            other_user = Fabricate(:user, name:'second')
            other_queue_item1 = Fabricate(:queue_item, video:video1, user:other_user, position:1)
            other_queue_item2 = Fabricate(:queue_item, video:video2, user:other_user, position:2)

            post :change, 'queue_item' => [
              { 'id' => other_queue_item1.id.to_s, 'position' => '3', 'rating' => '5' },
              { 'id' => other_queue_item2.id.to_s, 'position' => '4', 'rating' => '5' }
            ]

            expect(Review.count).to eq(0)
          end

          it 'does not change the ratings of someone else\'s review' do
            other_user = Fabricate(:user, name:'second')
            other_queue_item1 = Fabricate(:queue_item, video:video1, user:other_user, position:1)
            other_queue_item2 = Fabricate(:queue_item, video:video2, user:other_user, position:2)
            review1 = Fabricate(:review, video: video1, author: other_user, rating: 3)
            review2 = Fabricate(:review, video: video2, author: other_user, rating: 3)

            post :change, 'queue_item' => [
              { 'id' => other_queue_item1.id.to_s, 'position' => '3', 'rating' => '5' },
              { 'id' => other_queue_item2.id.to_s, 'position' => '4', 'rating' => '5' }
            ]

            expect(review1.reload.rating).to eq(3)
            expect(review2.reload.rating).to eq(3)
          end
        end
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :change }
    end
  end

end