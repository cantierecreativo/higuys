class LeaveWall < Struct.new(:guest, :wall)
  extend Command

  def execute
    if !guest || guest.wall != wall
      return
    end

    guest.update_attributes!(wall: nil)
    PushEvent.execute(wall, 'leave', guest_id: guest.id)
  end
end

