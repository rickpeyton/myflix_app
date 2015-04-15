class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friend_name
      t.string :friend_email
      t.text :message
      t.integer :user_id
      t.string :token
      t.timestamps
    end
  end
end
