class StorePhoto < Struct.new(:user, :s3_url)
  extend Command

  class InvalidInputException < RuntimeError; end

  def execute
    if !user || user.wall.blank? || !valid_url? || image.invalid?
      raise InvalidInputException
    end

    user.update_attributes(last_image: image)
    PushEvent.execute(user.wall, 'photo', user_id: user.id)

    image
  end

  def image_path
    @image_path ||= URI.parse(s3_url).path.gsub(/^\//, '')
  end

  def valid_url?
    s3_url.present? && s3_url.start_with?("http://#{ENV.fetch("S3_BUCKET_NAME")}")
  end

  private

  def image
    @image ||= Image.create(image_path: image_path, user: user)
  end
end

