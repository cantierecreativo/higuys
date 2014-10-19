class DeletePhoto < Struct.new(:image)
  extend Command

  def execute
    return if image.nil? || !image.persisted?
    s3_object.delete
    image.destroy
  end

  private

  def s3_object
    s3 = AWS::S3.new(access_key_id: ENV.fetch["S3_KEY_ID"], secret_access_key: ENV.fetch["S3_SECRET"])
    bucket = s3.buckets[ENV.fetch["S3_BUCKET_NAME"]]
    bucket.objects[image_path]
  end

  def read_object
    s3_object.read
  end

  def image_path
    image.image_path
  end
end

