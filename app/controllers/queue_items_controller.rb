class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    QueueItem.create(video: Video.find(params[:video_id]), user: current_user) if params[:video_id].present?
    redirect_to queue_items_path
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    redirect_to queue_items_path
  end


end