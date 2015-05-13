class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    update_order(current_user.queue_items.order(:order))
    redirect_to queue_items_path
  end

  private

    def queue_video(video)
      QueueItem.create(video: video, user: current_user) unless already_queued_video? video
    end

    def already_queued_video?(video)
      QueueItem.exists?(user: current_user, video_id: video.id)
    end

    def update_order(queue_items)
      queue_items.each_with_index do |queue_item, index|
        queue_item.update(order: index+1)
      end
    end
end