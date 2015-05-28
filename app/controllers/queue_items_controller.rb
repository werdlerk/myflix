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
    update_queue_items(params[:queue_item])
    QueueItem.normalize_positions(current_user)
    redirect_to my_queue_path
  end

  private

  def update_queue_items(queue_items)
    QueueItem.transaction do
      queue_items.each do |hash|
        queue_item = QueueItem.find(hash['id'])
        queue_item.update_attributes(position: hash['position'], rating: hash['rating']) if queue_item.user == current_user
      end
    end
  end

end