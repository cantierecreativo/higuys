class CreateWalls < ActiveRecord::Migration
  def change
    create_table :walls do |t|
      t.string :access_code
      t.timestamps
    end
    add_index :walls, :access_code, unique: true
  end
end

