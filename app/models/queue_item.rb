class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  before_create :set_position

  validates_numericality_of :position, only_integer: true, allow_blank: true
  validates_uniqueness_of :video, scope: :user

  def review
    @review ||= Review.find_by(author: user, video: video)
  end

  def review?
    !!review
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review?
      review.update_column(:rating, new_rating)
    else
      review = Review.new(author: user, rating: new_rating, video: video)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  def self.normalize_positions(user)
    user.queue_items.order(:position).each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  private
    def set_position
      self.position = self.user.queue_items.count + 1
    end

end