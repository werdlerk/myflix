class VideosController < ApplicationController

  def index
    @categories = Category.includes(:videos).reject { |category| category.videos.empty? }
  end

  def show
    @video = Video.find(params[:id])
  end
end