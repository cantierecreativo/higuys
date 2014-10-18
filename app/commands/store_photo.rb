class StorePhoto < Struct.new(:s3_url, :guest_id)
  def execute
    if guest && guest.wall.present? && image.valid?
      Pusher.trigger(channel_name, 'photo', guest_id: guest.id)
      true
    else
      false
    end
  end

  private

  def channel_name
    @channel_name ||= "demo-#{guest.wall.access_code}"
  end

  def guest
    @guest ||= Guest.where(id: guest_id).first
  end

  def image
    Image.create(s3_url: s3_url, guest: guest)
  end
end
