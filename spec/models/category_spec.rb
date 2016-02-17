require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe '#recent_videos' do

    it 'returns an empty array when there are no recent videos' do
      category = Category.create(name: 'Drama')

      expect(category.recent_videos).to eq([])
    end

    it 'returns an array with a single Video when there is one recent video' do
      video = Fabricate(:video, title: 'The Foreigner', description: "Foreigner")
      category = Category.create(name: 'Drama', videos: [video])

      expect(category.recent_videos).to eq([video])
    end

    it 'returns all of the videos if there are less then 6 videos' do
      category = Category.create(name: 'Drama')
      5.times do |i|
        category.videos << Fabricate(:video, title: "Video #{i}", description: "Video #{i}")
      end

      expect(category.recent_videos.size).to eq(5)
    end

    it 'returns only the most recent 6 videos' do
      category = Category.create(name: 'Drama')
      10.times do |i|
        category.videos << Fabricate(:video, title: "Video #{i}", description: "Video #{i}")
      end

      expect(category.recent_videos.size).to eq(6)
    end

    it 'returns an array of videos ordered by created_at descending' do
      category = Category.create(name: 'Drama')
      10.times do |i|
        category.videos << Fabricate(:video, title: "Video #{i}", description: "Video #{i}", created_at: (15-i).days.ago)
      end

      expect(category.recent_videos.map(&:title)).to eq(['Video 9', 'Video 8', 'Video 7', 'Video 6', 'Video 5', 'Video 4'])
    end
  end
end
