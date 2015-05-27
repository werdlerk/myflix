class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user: current_user)
    redirect_to my_queue_path
  end

  def destroy
    current_user.queue_items.find(params[:id]).destroy
    QueueItem.update_positions(current_user)
    redirect_to my_queue_path
  end

  def change
    QueueItem.change_positions(current_user, params[:queue_item])
    redirect_to my_queue_path
  end

end