require "spec_helper"

describe Review do
  context 'relations' do
    it { should belong_to(:video) }
    it { should belong_to(:author) }
  end

  context 'validations' do
    it { should validate_presence_of(:video) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:text) }
    it do
      should validate_numericality_of(:rating)
        .only_integer
        .is_less_than_or_equal_to(5)
        .is_greater_than_or_equal_to(1)
    end
  end

  it 'should order reviews by created_at descending' do
    video = Fabricate(:video, title: 'Mary Poppins')
    review1 = Fabricate(:review, text: 'review1', video: video)
    review2 = Fabricate(:review, text: 'review2', video: video)
    review3 = Fabricate(:review, text: 'review3', video: video)

    video.reload.reviews.map(&:text).should eq(['review3', 'review2', 'review1'])
  end

end