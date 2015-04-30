class AddLargeCoverToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_columns :videos, :large_cover_url, :small_cover_url
  end
end
