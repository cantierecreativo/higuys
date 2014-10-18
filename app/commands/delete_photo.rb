class DeletePhoto < Struct.new(:image)
  def execute
    return if image.nil? || !image.persisted?
    s3_object.delete
    image.destroy
  end

  def s3_object
    s3 = AWS::S3.new(access_key_id: ENV["S3_KEY_ID"], secret_access_key: ENV["S3_SECRET"])
    bucket = s3.buckets[ENV["S3_BUCKET_NAME"]]
    bucket.objects[filename]
  end

  def read_object
    s3_object.read
  end

  def filename
    URI.parse(image.s3_url).path.gsub('/', '')
  end
end
