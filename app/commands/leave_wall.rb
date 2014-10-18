class LeaveWall < Struct.new(:wall, :session)
  def self.execute(wall, session)
    new(wall, session).execute
  end

  def execute
    if !guest || guest.wall != wall
      return
    end

    guest.update_attributes!(wall: nil)
    channel_name = "demo-#{wall.access_code}"
    PushEvent.execute(wall, 'leave', guest_id: guest.id)
  end

  private

  def guest
    @guest ||= if (( guest_id = session[:guest_id] ))
                 Guest.find(guest_id)
               else
                 nil
               end
  end
end

