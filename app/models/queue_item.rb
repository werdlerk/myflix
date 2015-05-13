class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  before_create :set_order

  default_scope { order(:order) }

  def rating
    review = Review.where(author: user, video: video).first
    review.rating if review
  end

  def category_name
    category.name
  end

  private
    def set_order
      self.order = self.user.queue_items.count + 1
    end

end