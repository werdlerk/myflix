class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  default_scope { order(:order) }
end