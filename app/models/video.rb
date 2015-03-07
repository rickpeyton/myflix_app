class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(search_query)
    return [] if search_query.blank?
    where("title LIKE ?", "%#{search_query}%").order(created_at: :desc)
  end

end
