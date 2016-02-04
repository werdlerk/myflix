class Admin::VideosController < AdminController

  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "Video created"
      redirect_to admin_path
    else
      render 'new'
    end
  end


  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id)
  end

end
