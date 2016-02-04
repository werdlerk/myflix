class VideosController < AuthenticatedController

  def index
    @categories = Category.includes(:videos).reject { |category| category.videos.empty? }
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reload.reviews.includes(:author)
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:q])
  end
end
