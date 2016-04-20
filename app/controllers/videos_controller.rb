class VideosController < AuthenticatedController

  def index
    @categories = Category.includes(:videos).reject { |category| category.videos.empty? }
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews.includes(:author).reload
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:q])
  end

  def advanced_search
    @videos = []
    if params[:query]
      @videos = Video.search(params[:query], reviews: params[:reviews].to_i == 1, rating_from: params[:rating_from], rating_to: params[:rating_to]).records.to_a
    end
  end
end
