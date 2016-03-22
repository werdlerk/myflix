require 'spec_helper'

describe VideoDecorator do
  let(:video) { Fabricate(:video) }
  let(:decorator) { video.decorate }

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

end
