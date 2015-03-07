class ChangeTableVideos < ActiveRecord::Migration
  def change
    change_table(:videos) do |t|
      t.column :category_id, :integer
    end
  end
end
