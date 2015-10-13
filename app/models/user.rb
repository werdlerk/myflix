class User < ActiveRecord::Base
  has_many :reviews, -> { order(:created_at).reverse_order }
  has_many :queue_items, -> { order(:position) }
  has_many :followships
  has_many :followers, through: :followships

  has_secure_password(validations: false)

  validates_presence_of :email, :password, :name
  validates :email, uniqueness: true

  def gravatar_image
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=40"
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end