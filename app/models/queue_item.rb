class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  before_create :set_position

  validates_numericality_of :position, only_integer: true, allow_blank: true
  validates_uniqueness_of :video, scope: :user

  def rating
    review = Review.where(author: user, video: video).first
    review.rating if review
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