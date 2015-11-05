class User < ActiveRecord::Base
  has_many :reviews, -> { order(:created_at).reverse_order }
  has_many :queue_items, -> { order(:position) }

  has_many :following_relationships, class_name: Relationship, foreign_key: :follower_id
  has_many :followers, through: :leading_relationships

  has_many :leading_relationships, class_name: Relationship, foreign_key: :leader_id
  has_many :leaders, through: :following_relationships


  has_secure_password(validations: false)

  validates_presence_of :email, :name
  validates_presence_of :password, on: :create
  validates :email, uniqueness: true

  def gravatar_image
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=40"
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end