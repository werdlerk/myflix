class Admin::VideosController < AdminController

  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new(video_params)
    @categories = Category.all

    if @video.save
      flash[:success] = "You have successfully added the video #{@video.title}."
      redirect_to admin_path
    else
      render 'new'
    end
  end


  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :large_cover_cache, :small_cover, :small_cover_cache)
  end

end
