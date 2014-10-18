class AwsPolicyGenerator
  extend Command

  EXPIRATION_TIME = 3.days

  def execute
    s3 = AWS::S3.new(
      access_key_id: ENV["S3_KEY_ID"],
      secret_access_key: ENV["S3_SECRET"]
    )
    bucket = s3.buckets[ENV["S3_BUCKET_NAME"]]
    object = bucket.objects[filename]
    presign = AWS::S3::PresignV4.new(object)
    policy = presign.presign(
      :put,
      expires: Time.now.to_i + EXPIRATION_TIME,
      acl: "public-read"
    )

    OpenStruct.new upload_url: force_http_port(policy.clone).to_s,
                   url: url(policy.clone).to_s
  end

  private

  def url(policy)
    force_http_port(policy).tap { |uri| uri.query = nil }
  end

  def force_http_port(uri)
    uri.port = 80
    uri
  end

  def filename
    @filename ||= "#{SecureRandom.hex}.jpg"
  end
end

