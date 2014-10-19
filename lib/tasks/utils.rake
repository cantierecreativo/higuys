namespace :hg do
  desc "Puge walls inactive since more than 48 hours"
  task purge_inactive_walls: :environment do
    puts PurgeInactiveWalls.execute(48.hours)
  end

  desc "Kick users not active in the last 5 minutes"
  task kick_inactive_users: :environment do
    puts KickInactiveUsers.execute(5.minutes)
  end
end
