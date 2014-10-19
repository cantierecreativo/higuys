class AddGithubUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_user_id, :string
    add_index :users, :github_user_id, unique: true
  end
end

