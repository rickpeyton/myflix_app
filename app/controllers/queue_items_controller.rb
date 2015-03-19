class QueueItemsController < ApplicationController
  before_filter :require_user, only: [:index, :create, :destroy, :update_my_queue]
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    if already_present_in_queue?(video)
      flash[:danger] = "#{video.title} is already in your queue."
    else
      create_queue_item(video)
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user.queue_items.where("position > ?", queue_item.position).present?
      current_user.queue_items.where("position > ?", queue_item.position).each do |item|
        item.update(position: item.position -= 1)
      end
    end
    queue_item.destroy if current_user == queue_item.user
    redirect_to my_queue_path
  end

  def update_my_queue
    @queue_items = params[:queue_items]
    @queue_items.each do |queue_item|
      QueueItem.find(queue_item[:id]).update(position: queue_item[:position])
    end
    redirect_to my_queue_path
  end

  private

    def create_queue_item(video)
      QueueItem.create(user: current_user, video: video,
                       position: add_to_end_of_queue)
    end

    def already_present_in_queue?(video)
      current_user.queue_items.find_by(video_id: video.id).present?
    end

    def add_to_end_of_queue
      current_user.queue_items.count + 1
    end
end
