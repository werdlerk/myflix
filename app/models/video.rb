class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name "myflix_#{Rails.env}"

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  validates :title, :description, :video_url, presence:true

  def self.search_by_title(search_term)
    return [] if search_term.empty?
    Video.where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end

  def self.search(query, options = {})
    search_defintion = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }
    search_defintion[:query][:multi_match][:fields] << "reviews.text" if options[:reviews]

    __elasticsearch__.search search_defintion
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def as_indexed_json(options={})
    as_json(
      only: [ :title, :description ],
      include: {
        reviews: { only: [ :rating, :text ]}
      }
    )
  end
end
