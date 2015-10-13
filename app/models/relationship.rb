class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower, class_name: User

  validates :follower, uniqueness: true
end