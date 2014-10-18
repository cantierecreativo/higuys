class SetupWall < Struct.new(:session)
  ACCESS_CODE_SIZE = 8
  class GuestAlreadyHasAWall < RuntimeError; end

  def self.execute(session)
    new(session).execute
  end

  def execute
    raise GuestAlreadyHasAWall if guest.wall

    guest.update_attributes!(wall: wall)
    session[:guest_id] = guest.id
    wall
  end

  private

  def wall
    @wall ||= begin
                wall = nil
                loop do
                  access_code = SecureRandom.hex(ACCESS_CODE_SIZE)
                  wall = Wall.create(access_code: access_code)
                  break if wall.persisted?
                end
                wall
              end
  end

  def guest
    if (( guest_id = session[:guest_id] ))
      Guest.find(guest_id)
    else
      Guest.create!
    end
  end
end

