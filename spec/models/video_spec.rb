require 'spec_helper'

describe Video do
  context 'relations' do
    it { should belong_to(:category) }
    it { should have_many(:reviews).order('created_at DESC') }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe :search_by_title do
    before(:each) do
      Video.create(title: 'Video one', description: 'Video one is awesome', created_at: 1.day.ago)
      Video.create(title: 'Video two', description: 'Video two is awesome')
      Video.create(title: 'Family Guy', description: 'Family Guy by Seth McFarland')
    end

    it 'returns an empty array when there is no match' do
      videos = Video.search_by_title('unknown title')

      expect(videos.empty?).to be true
    end

    it 'returns an array with a single Video when there is an exact match' do
      videos = Video.search_by_title('Family Guy')

      expect(videos.first.title).to eq('Family Guy')
    end

    it 'returns an array with a single Video when there is a partial match' do
      videos = Video.search_by_title('Guy')

      expect(videos.first.title).to eq('Family Guy')
    end

    it 'returns an array with two Videos ordered by created_at' do
      videos = Video.search_by_title('Video')

      expect(videos.map(&:title)).to eq(['Video two', 'Video one'])
    end

    it 'returns an empty array when there is an empty search term' do
      videos = Video.search_by_title('')

      expect(videos).to eq([])
    end
  end

  describe :average_rating do
    let(:video) do
      Video.create(title: 'Video one', description: 'Video one is awesome')
    end

    it 'returns 0 when there are no comments' do
      expect(video.average_rating).to eq 0
    end

    it 'returns the rating of the comment when there is one comment' do
      Fabricate(:review, rating: 3, video: video)

      expect(video.average_rating).to eq 3.0
    end
    it 'returns the average rating of 3 comments' do
      Fabricate(:review, rating: 1, video: video)
      Fabricate(:review, rating: 2, video: video)
      Fabricate(:review, rating: 5, video: video)

      expect(video.average_rating).to eq 2.7
    end
  end
end