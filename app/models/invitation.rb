class Invitation < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'

  validates :name, :email, :message, presence: true

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.hex
  end
end
