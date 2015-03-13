class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  validates_presence_of :title, :description

  def self.search_by_title(search_query)
    return [] if search_query.blank?
    where("title LIKE ?", "%#{search_query}%").order(created_at: :desc)
  end

  def average_rating
    total = 0
    self.reviews.each { |review| total += review.rating }
    (total.to_f / self.reviews.count.to_f).round(1)
  end

end
