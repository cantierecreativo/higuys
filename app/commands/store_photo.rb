class StorePhoto < Struct.new(:s3_url, :guest_id)
  def execute
    if !guest || guest.wall.blank? || image.invalid?
      return false
    end
    guest.update_attributes(last_image: image)
    PushEvent.execute(guest.wall, 'photo', guest_id: guest.id)
    true
  end

  private

  def channel_name
    @channel_name ||= "demo-#{guest.wall.access_code}"
  end

  def guest
    @guest ||= Guest.where(id: guest_id).first
  end

  def image
    @image ||= Image.create(s3_url: s3_url, guest: guest)
  end
end

