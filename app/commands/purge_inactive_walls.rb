class PurgeInactiveWalls < Struct.new(:since)
  extend Command

  def execute
    Wall.inactive_since(since).each(&:destroy)
  end
end
