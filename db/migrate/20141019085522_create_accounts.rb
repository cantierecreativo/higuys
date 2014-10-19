class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.belongs_to :wall, null: false
      t.timestamps
    end
   add_index :accounts, :slug, unique: true
  end
end

