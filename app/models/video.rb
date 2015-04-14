class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, :description, presence:true

  def self.search_by_title(search_term)
    return [] if search_term.empty?
    Video.where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end
end