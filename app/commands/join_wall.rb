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

      channel_name = "demo-#{wall.access_code}"
      Pusher.trigger(channel_name, 'join', guest_id: guest.id)
      true
    else
      false
    end
  end

  private

  def guest
    @guest ||= if (( guest_id = session[:guest_id] ))
                 Guest.find(guest_id)
               else
                 Guest.create!
               end
  end
end
