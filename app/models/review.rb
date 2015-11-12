class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'

  validates_presence_of :video, :author, :rating, :text
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to:5 }

  delegate :title, to: :video, prefix: :video
end