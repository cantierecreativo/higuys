class StorePhoto < Struct.new(:s3_url, :session)
  extend Command

  class InvalidInputException < RuntimeError; end

  def execute
    if !guest || guest.wall.blank? || image.invalid?
      raise InvalidInputException
    end

    guest.update_attributes(last_image: image)
    PushEvent.execute(guest.wall, 'photo', guest_id: guest.id)

    image
  end

  private

  def guest
    @guest ||= Guest.where(id: session[:guest_id]).first
  end

  def image
    @image ||= Image.create(s3_url: s3_url, guest: guest)
  end
end
