class QueueItemsController < ApplicationController
  before_filter :require_user, only: [:index, :create, :destroy, :update]
  def index
    @user = current_user
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

  def update
    @queue_items = params[:user][:queue_item]
    @queue_items.each do |key, value|
      current_user.queue_items.find(key).update(position: value[:position])
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
