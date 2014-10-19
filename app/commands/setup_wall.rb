class SetupWall < Struct.new(:guest)
  extend Command

  ACCESS_CODE_SIZE = 8

  def execute
    if guest.wall
      raise GuestAlreadyHasAWallException.new(guest.wall)
    end

    guest.update_attributes!(wall: wall)
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
end

