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
    current_user.queue_items.find(params[:id]).destroy
    update_position(current_user.queue_items.order(:position))
    redirect_to my_queue_path
  end

  def change
    ordered_hash = params[:queue_item].sort_by { |queue_item| queue_item["position"].to_i }
    QueueItem.transaction do
      ordered_hash.each_with_index do |hash, index|
        queue_item = QueueItem.find(hash["id"])
        queue_item.update(position: index+1) if queue_item.user == current_user
      end
    end
    redirect_to my_queue_path
  end

  private

    def queue_video(video)
      QueueItem.create(video: video, user: current_user) unless already_queued_video? video
    end

    def already_queued_video?(video)
      QueueItem.exists?(user: current_user, video_id: video.id)
    end

    def update_position(queue_items)
      queue_items.each_with_index do |queue_item, index|
        queue_item.update(position: index+1)
      end
    end
end