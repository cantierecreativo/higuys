class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.belongs_to :wall
      t.timestamps
    end
  end
end

