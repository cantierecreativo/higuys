class JoinWall < Struct.new(:user, :wall)
  extend Command

  MAX_USERS_FOR_WALL = 12

  def execute
    if user.wall && user.wall != wall
      raise UserAlreadyHasAWallException.new(user.wall)
    end

    if wall.users.count >= MAX_USERS_FOR_WALL
      raise TooManyUsersOnWallException.new(wall)
    end

    if user.wall.nil?
      user.update_attributes!(wall: wall)
      PushEvent.execute(wall, 'join', user_id: user.id)
      return true
    else
      return false
    end
  end
end
