class VideosController < ApplicationController
  before_action :require_user, only: [:index, :show, :search]

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:search_terms])
  end
end
