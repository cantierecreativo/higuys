namespace :hg do
  desc "Purge walls inactive since more than 48 hours"
  task purge_inactive_walls: :environment do
    puts PurgeInactiveWalls.execute(48.hours)
  end

  desc "Kick users not active in the last 5 minutes and destroy empties"
  task purge_users: :environment do
    puts KickInactiveUsers.execute(5.minutes).to_s + " kicked!"
    puts PurgeEmptyUsers.execute(5.minutes).to_s + " destroyed!"
  end
end
