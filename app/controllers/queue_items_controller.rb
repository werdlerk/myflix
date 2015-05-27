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
    add_or_update_ratings(params[:queue_item])
    redirect_to my_queue_path
  end

  private

  def change_positions(queue_items)
    QueueItem.transaction do
      queue_items.each do |hash|
        queue_item = QueueItem.find(hash['id'])
        queue_item.update(position: hash['position']) if queue_item.user == current_user
      end
      QueueItem.normalize_positions(current_user)
    end
  end

  def add_or_update_ratings(queue_items)
    queue_items.each do |hash|
      queue_item = QueueItem.find(hash['id'])
      next if queue_item.user != current_user || hash['rating'].nil? || hash['rating'].empty?

      if queue_item.review?
        review = queue_item.review
        review.rating = hash['rating']
        review.save(validate:false)
      else
        Review.new(author: current_user, video: queue_item.video, rating: hash['rating']).save(validate:false)
      end
    end

  end

end