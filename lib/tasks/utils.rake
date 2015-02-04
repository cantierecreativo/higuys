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

  desc "Export Image table content to CSV and delete rows"
  task purge_images: :environment do
    puts PurgeImages.execute(limit: 9_000_000).to_s + " images saved and deleted!"
  end
end
