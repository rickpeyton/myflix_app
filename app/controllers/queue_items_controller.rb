class QueueItemsController < ApplicationController
  before_filter :require_user, only: [:index, :create]
  def index
    @queue_items = current_user.queue_items.order(:position)
  end

  def create
    if QueueItem.where("video_id = ? AND user_id = ?",
                       params[:video_id], params[:user_id]).exists?
      existing = QueueItem.where("video_id = ? AND user_id = ?",
                                 params[:video_id], params[:user_id]).first
      flash[:danger] = "#{existing.video_title} is already number #{existing.position} your queue."
    else
      queue_item = QueueItem.create(user_id: params[:user_id],
                                    video_id: params[:video_id])
      queue_item.update(position: queue_item.set_queue_position)
      queue_item.save
    end
    redirect_to my_queue_path
  end
end
