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
    begin
      update_my_queue_items
      update_my_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "An invalid queue position was entered."
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

    def update_my_queue_items
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |queue_item|
          QueueItem.find(queue_item[:id]).update!(position: queue_item[:position])
        end
      end
    end

    def update_my_queue_positions
      current_user.queue_items.each_with_index do |item, index|
        item.update(position: index + 1)
      end
    end
end
