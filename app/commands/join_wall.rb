class JoinWall < Struct.new(:guest, :wall)
  extend Command

  MAX_USERS_FOR_WALL = 12

  def execute
    if guest.wall && guest.wall != wall
      raise GuestAlreadyHasAWallException.new(guest.wall)
    end

    if wall.guests.count >= MAX_USERS_FOR_WALL
      raise TooManyUsersOnWallException.new(wall)
    end

    if guest.wall.nil?
      guest.update_attributes!(wall: wall)
      PushEvent.execute(wall, 'join', guest_id: guest.id)
      return true
    else
      return false
    end
  end
end

