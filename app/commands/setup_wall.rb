class SetupWall < Struct.new(:session)
  ACCESS_CODE_SIZE = 8

  def self.execute(session)
    new(session).execute
  end

  def execute
    wall = generate_wall
  end

  private

  def generate_wall
    loop do
      access_code = SecureRandom.hex(ACCESS_CODE_SIZE)
      wall = Wall.create(access_code: access_code)
      return wall if wall.persisted?
    end
  end
end

