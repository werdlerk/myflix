class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :author, foreign_key: 'user_id', class_name: 'User'

  validates :name, :email, :message, presence: true

  def clear_token!
    update_column(:token, nil)
  end
end
