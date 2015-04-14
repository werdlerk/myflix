class User < ActiveRecord::Base
  has_many :reviews

  has_secure_password(validations: false)

  validates_presence_of :email, :password, :name
  validates :email, uniqueness: true
end