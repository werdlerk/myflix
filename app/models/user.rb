class User < ActiveRecord::Base
  include Tokenable

  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }

  has_many :following_relationships, class_name: Relationship, foreign_key: :follower_id
  has_many :followers, through: :leading_relationships

  has_many :leading_relationships, class_name: Relationship, foreign_key: :leader_id
  has_many :leaders, through: :following_relationships

  has_many :invitations

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

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow!(another_user)
    self.following_relationships.create!(leader: another_user) if can_follow?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def clear_token!
    update(token: nil, token_expiration: nil)
  end

  def token_expired?
    token.nil? || token_expiration.nil? || DateTime.now >= token_expiration
  end

end
