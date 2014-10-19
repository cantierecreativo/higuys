class ManageSecretToken < ActiveRecord::Migration
  def change
    add_index :users, :secret_token, unique: true
    execute "UPDATE users SET secret_token=md5(random()::text) WHERE secret_token IS NULL OR secret_token = ''"
    change_column :users, :secret_token, :string, null: false
  end
end

