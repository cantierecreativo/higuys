class JoinAccount < Struct.new(:user, :account)
  extend Command

  MAX_USERS_FOR_WALL = 12

  def execute
    if account.wall.users.count >= MAX_USERS_FOR_WALL
      raise TooManyUsersOnWallException.new(account.wall)
    end

    user.update_attributes!(wall: account.wall)
    PushEvent.execute(account.wall, 'join', user_id: user.id)
  end
end

