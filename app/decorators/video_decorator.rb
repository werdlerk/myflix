class VideoDecorator
  extend Forwardable

  def_delegators :video, :title, :description, :large_cover_url, :video_url
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def rating
    if video.reviews.present?
      "#{video.average_rating}/5.0"
    else
      "Be the first to rate this video!"
    end
  end

end
