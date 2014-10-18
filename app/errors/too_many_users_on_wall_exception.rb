class TooManyUsersOnWallException < RuntimeError
  attr_reader :wall

  def initialize(wall)
    @wall = wall
  end
end
