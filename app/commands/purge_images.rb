require 'csv'

class PurgeImages
  extend Command

  attr_reader :limit

  def initialize(limit: nil)
    @limit = limit
  end

  def execute
    if limit && Image.count > limit
      export_images_table_to_zipped_csv
      upload_csv_to_s3
      delete_images
    else
      0
    end
  end

  private

  def csv_path
    timestamp = Time.now.strftime("%Y.%m.%d-%H.%M.%S")
    @csv_path ||= Rails.root.join("tmp", "images-#{timestamp}.csv.gz")
  end

  def export_images_table_to_zipped_csv
    csv = CSV.generate do |row|
      row << Image.attribute_names
      Image.find_each do |image|
        row << image.attributes.values
      end
    end
    Zlib::GzipWriter.open(csv_path) do |gz|
      gz.write(csv)
    end
  end

  def upload_csv_to_s3
    s3 = AWS::S3.new(access_key_id: ENV.fetch("S3_KEY_ID"), secret_access_key: ENV.fetch("S3_SECRET"))
    bucket = s3.buckets[ENV.fetch("S3_BUCKET_NAME")]
    key = File.join("imagesdump", File.basename(csv_path))
    bucket.objects[key].write(file: csv_path)
  end

  def delete_images
    Image.delete_all
  end
end
