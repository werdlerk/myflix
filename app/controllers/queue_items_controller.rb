class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = QueueItem.where(user:current_user)
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    redirect_to queue_items_path
  end


end