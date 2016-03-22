class ReviewsController < AuthenticatedController

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params.merge(author: current_user))

    if @review.save
      flash[:success] = 'Review added to video!'
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.includes(:author).reload
      @decorator = @video.decorator
      render 'videos/show'
    end
  end

  private

    def review_params
      params.require(:review).permit(:rating, :text)
    end
end
