class LeaveWall < Struct.new(:wall, :session)
  extend Command

  def execute
    if !guest || guest.wall != wall
      return
    end

    guest.update_attributes!(wall: nil)
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

