class StorePhoto < Struct.new(:s3_url, :session)
  extend Command

  class InvalidInputException < RuntimeError; end

  def execute
    if !guest || guest.wall.blank? || !valid_url? || image.invalid?
      raise InvalidInputException
    end

    guest.update_attributes(last_image: image)
    PushEvent.execute(guest.wall, 'photo', guest_id: guest.id)

    image
  end

  def image_path
    @image_path ||= URI.parse(s3_url).path.gsub(/^\//, '')
  end

  def valid_url?
    s3_url.present? && s3_url.start_with?("http://#{ENV.fetch["S3_BUCKET_NAME"]}")
  end

  private

  def guest
    @guest ||= Guest.where(id: session[:guest_id]).first
  end

  def image
    @image ||= Image.create(image_path: image_path, guest: guest)
  end
end

