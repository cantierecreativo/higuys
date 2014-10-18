class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :guest_id, index: true, null: false
      t.string :s3_url, null: false

      t.timestamps
    end
  end
end
