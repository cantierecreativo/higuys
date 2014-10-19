namespace :hg do
  desc "Puge walls inactive since more than 48 hours"
  task purge_inactive_walls: :environment do
    PurgeInactiveWalls.execute(48.hours)
  end
end

