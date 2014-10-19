class AddStatusMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status_message, :string
  end
end
