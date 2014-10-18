class JoinWall < Struct.new(:wall, :session)
  MAX_USERS_FOR_WALL = 12

  def self.execute(wall, session)
    new(wall, session).execute
  end

  def execute
    if guest.wall && guest.wall != wall
      raise GuestAlreadyHasAWallException.new(guest.wall)
    end

    if wall.guests.count >= MAX_USERS_FOR_WALL
      raise TooManyUsersOnWallException.new(wall)
    end

    if guest.wall.nil?
      guest.update_attributes!(wall: wall)
      session[:guest_id] = guest.id

      PushEvent.execute(wall, 'join', guest_id: guest.id)
      return true
    else
      return false
    end
  end

  private

  def guest
    @guest ||= Guest.where(id: session[:guest_id]).first_or_create!
  end
end

