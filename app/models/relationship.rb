class Relationship < ActiveRecord::Base
  belongs_to :leader, class_name: User
  belongs_to :follower, class_name: User

  validates_uniqueness_of :follower, scope: :leader
end