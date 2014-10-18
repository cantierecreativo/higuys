class StorePhoto < Struct.new(:s3_url, :guest_id)
  class InvalidInputException < RuntimeError; end

  def self.execute(*args)
    new(*args).execute
  end

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
    @guest ||= Guest.where(id: guest_id).first
  end

  def image
    @image ||= Image.create(s3_url: s3_url, guest: guest)
  end
end

