class RenameImagesFilenameIntoImagePath < ActiveRecord::Migration
  def change
    rename_column :images, :filename, :image_path
  end
end

