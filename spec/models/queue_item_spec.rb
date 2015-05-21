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