class StiUsers < ActiveRecord::Migration
  def change
    rename_table :guests, :users
    add_column :users, :type, :string
    execute "UPDATE users SET type='Guest' WHERE 1=1"
    change_column :users, :type, :string, null: false
    rename_column :images, :guest_id, :user_id
  end
end

