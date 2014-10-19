class KickInactiveUsers < Struct.new(:since)
  extend Command

  def execute
    User.inactive_in_the_last(since).where.not(wall_id: nil).update_all(wall_id: nil)
  end
end
