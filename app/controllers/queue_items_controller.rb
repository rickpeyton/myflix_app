class QueueItemsController < ApplicationController
  before_filter :require_user, only: [:index]
  def index
    @queue_items = current_user.queue_items
  end
end
