class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if object.reviews.present?
      "#{object.average_rating}/5.0"
    else
      "Be the first to rate this video!"
    end
  end

end
