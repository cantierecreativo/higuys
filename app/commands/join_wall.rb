class JoinWall < Struct.new(:wall, :session)
  def self.execute(wall, session)
    new(wall, session).execute
  end

  def execute
    if guest.wall && guest.wall != wall
      raise GuestAlreadyHasAWallException.new(guest.wall)
    end
    guest.update_attributes!(wall: wall)
    session[:guest_id] = guest.id
  end

  private

  def guest
    if (( guest_id = session[:guest_id] ))
      Guest.find(guest_id)
    else
      Guest.create!
    end
  end
end

