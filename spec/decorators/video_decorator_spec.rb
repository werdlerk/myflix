require 'spec_helper'

describe VideoDecorator do
  let(:video) { Fabricate(:video, title: 'My little pony', description: 'Animated horses', video_url: 'http://youtube.com') }
  let(:decorator) { VideoDecorator.new(video) }

  describe '#title' do
    it 'returns the video title' do
      expect(decorator.title).to eq 'My little pony'
    end
  end

  describe '#rating' do
    context 'with video having a review' do
      let(:author) { Fabricate(:user) }
      let!(:review) { Fabricate(:review, video: video, rating: 2) }

      it 'shows the average rating' do
        expect(decorator.rating).to eq '2.0/5.0'
      end
    end

    context 'without video having a review' do
      it 'shows a standard text' do
        expect(decorator.rating).to eq 'Be the first to rate this video!'
      end
    end
  end

  describe '#description' do
    it 'shows the video description' do
      expect(decorator.description).to eq 'Animated horses'
    end
  end

  describe '#large_cover_url' do
    it 'shows the large_cover_url' do
      expect(decorator.large_cover_url).to eq video.large_cover_url
    end
  end

  describe '#video_url' do
    it 'shows the video url' do
      expect(decorator.video_url).to eq 'http://youtube.com'
    end
  end
end
