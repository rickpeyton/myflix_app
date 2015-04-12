class AddTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :token
    end
  end
end
