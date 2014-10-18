class JoinWall < Struct.new(:wall, :session)
  class GuestAlreadyHasAWall < RuntimeError; end

  def self.execute(wall, session)
    new(wall, session).execute
  end

  def execute
    raise GuestAlreadyHasAWall if guest.wall
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

