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
    QueueItem.normalize_positions(current_user)
    redirect_to my_queue_path
  end

  def change
    change_positions(params[:queue_item])
    redirect_to my_queue_path
  end

  private

  def change_positions(queue_items)
    QueueItem.transaction do
      queue_items.each do |hash|
        QueueItem.find(hash['id']).update(position: hash['position'])
      end
      QueueItem.normalize_positions(current_user)
    end
  end

end