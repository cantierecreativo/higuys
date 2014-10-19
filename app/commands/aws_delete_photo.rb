class AwsDeletePhoto < Struct.new(:image_path)
  extend Command

  def execute
    s3_object.delete
  end

  private

  def s3_object
    s3 = AWS::S3.new(access_key_id: ENV.fetch("S3_KEY_ID"), secret_access_key: ENV.fetch("S3_SECRET"))
    bucket = s3.buckets[ENV.fetch("S3_BUCKET_NAME")]
    bucket.objects[image_path]
  end
end
