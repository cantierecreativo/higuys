class WallsController < ApplicationController
  def create
    wall = SetupWall.execute(session)
    redirect_to wall_path(wall)
  rescue SetupWall::GuestAlreadyHasAWall
    redirect_to root_path, alert: "You're already part of another wall!"
  end

  def show
  end
end

