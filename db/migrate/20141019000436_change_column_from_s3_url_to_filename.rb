class ChangeColumnFromS3UrlToFilename < ActiveRecord::Migration
  def change
    rename_column :images, :s3_url, :filename
  end
end
