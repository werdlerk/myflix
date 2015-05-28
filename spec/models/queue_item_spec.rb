require "spec_helper"

describe QueueItem do
  context 'relations' do
    it { should belong_to(:video) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_numericality_of(:position).only_integer }
  end

  context 'methods' do
    let(:video) { Fabricate(:video, title: 'Monk') }
    let(:user) { Fabricate(:user) }

    describe '#video_title' do
      it 'returns the title of the associated video' do
        queue_item = Fabricate(:queue_item, video:video, user:user)
        expect(queue_item.video_title).to eq('Monk')
      end
    end

    describe '#review' do
      it 'returns the review from the video when it exists' do
        review = Fabricate(:review, author: user, video: video, rating: 3)
        queue_item = Fabricate(:queue_item, user:user, video:video)

        expect(queue_item.review).to eq(review)
      end

      it 'returns nil when there is no review available of the video' do
        queue_item = Fabricate(:queue_item, user:user, video:video)

        expect(queue_item.review).to be_nil
      end
    end

    describe '#rating' do
      it 'returns the rating from the review when the review is present' do
        review = Fabricate(:review, author: user, video: video, rating: 3)
        queue_item = Fabricate(:queue_item, user:user, video:video)

        expect(queue_item.rating).to eq(3)
      end

      it 'returns nil when there is no review available' do
        queue_item = Fabricate(:queue_item, user:user, video:video)
        expect(queue_item.rating).to be_nil
      end
    end

    describe '#rating=' do
      it 'changes the rating of the review when there is a review present' do
        review = Fabricate(:review, author: user, video: video, rating: 3)
        queue_item = Fabricate(:queue_item, user:user, video:video)

        queue_item.rating = 2

        expect(Review.first.rating).to eq(2)
      end

      it 'removes the rating of the review if there is a review present' do
        review = Fabricate(:review, author: user, video: video, rating: 3)
        queue_item = Fabricate(:queue_item, user:user, video:video)

        queue_item.rating = nil

        expect(review.reload.rating).to be_nil
      end

      it 'creates a new review with the given rating when there is no review' do
        queue_item = Fabricate(:queue_item, user:user, video:video)

        queue_item.rating = 3

        expect(Review.first.rating).to eq(3)
      end
    end

    describe '#category_name' do
      it 'returns the category name of the video' do
        category = Fabricate(:category, name: 'SciFi')
        video = Fabricate(:video, category:category)
        queue_item = Fabricate(:queue_item, user:user, video:video)
        expect(queue_item.category_name).to eq('SciFi')
      end
    end

    describe 'normalize_positions' do
      it 'does not give an error when there are no queue items' do
        expect {
          QueueItem.normalize_positions(user)
        }.not_to raise_error
      end

      it 'does not give an error when there is one queue item' do
        Fabricate(:queue_item, user:user, video:video)

        expect {
          QueueItem.normalize_positions(user)
        }.not_to raise_error
      end

      it 'updates the positions of the queue items' do
        category = Fabricate(:category, name: 'SciFi')
        video1 = Fabricate(:video, category:category)
        video2 = Fabricate(:video, category:category)
        queue_item1 = Fabricate(:queue_item, user:user, video:video1)
        queue_item2 = Fabricate(:queue_item, user:user, video:video2)
        queue_item1.update(position: 5)
        queue_item2.update(position: 3)

        QueueItem.normalize_positions(user)

        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    describe '#category' do
      it 'returns the category of the video' do
        category = Fabricate(:category, name: 'SciFi')
        video = Fabricate(:video, category:category)
        queue_item = Fabricate(:queue_item, user:user, video:video)
        expect(queue_item.category).to eq(category)
      end
    end

    describe '#set_position' do
      it 'sets the position after save' do
        queue_item = QueueItem.create(user:user, video:video)

        expect(queue_item.position).to be_present
      end

      it 'sets the position number higher then 0' do
        queue_item = QueueItem.create(user:user, video:video)

        expect(queue_item.position).to be > 0
      end
    end
  end

end