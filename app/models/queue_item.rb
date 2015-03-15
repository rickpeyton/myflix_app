class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end

  def category_name
    category.name
  end

  def set_queue_position
    existing_positions = user.queue_items.where.not(position: nil)
    if existing_positions.empty?
      1
    else
      existing_positions.order(:position).last.position + 1
    end
  end
end
