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

    describe '#category_name' do
      it 'returns the category name of the video' do
        category = Fabricate(:category, name: 'SciFi')
        video = Fabricate(:video, category:category)
        queue_item = Fabricate(:queue_item, user:user, video:video)
        expect(queue_item.category_name).to eq('SciFi')
      end
    end

    describe 'update_positions' do
      it 'does not give an error when there are no queue items' do
        expect {
          QueueItem.update_positions(user)
        }.not_to raise_error
      end

      it 'does not give an error when there is one queue item' do
        Fabricate(:queue_item, user:user, video:video)

        expect {
          QueueItem.update_positions(user)
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

        QueueItem.update_positions(user)

        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    describe 'change_positions' do
      it 'does not give an error when there are no queue items' do
        expect {
          QueueItem.change_positions(user, [])
        }.not_to raise_error
      end

      it 'does not give an error when there is one queue item' do
        queue_item = Fabricate(:queue_item, user:user, video:video)

        expect {
          QueueItem.change_positions(user, [{'id' => queue_item.id, 'position' => 5}])
        }.not_to raise_error
      end

      it 'changes the positions of the queue items' do
        category = Fabricate(:category, name: 'SciFi')
        video1 = Fabricate(:video, category:category)
        video2 = Fabricate(:video, category:category)
        queue_item1 = Fabricate(:queue_item, user:user, video:video1)
        queue_item2 = Fabricate(:queue_item, user:user, video:video2)

        QueueItem.change_positions(user, [
          { 'id' => queue_item1.id, 'position' => 5},
          { 'id' => queue_item2.id, 'position' => 3}
        ])

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