class LeaveWall < Struct.new(:user, :wall)
  extend Command

  def execute
    if !user || user.wall != wall
      return
    end

    user.update_attributes!(wall: nil)
    PushEvent.execute(wall, 'leave', user_id: user.id)
  end
end

