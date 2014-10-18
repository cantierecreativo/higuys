class AddLastImageToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :last_image_id, :integer, index: true
  end
end
