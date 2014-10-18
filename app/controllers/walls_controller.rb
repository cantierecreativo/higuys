class WallsController < ApplicationController
  def create
    wall = SetupWall.execute(session)
    redirect_to wall_path(wall)
  rescue SetupWall::GuestAlreadyHasAWall
    redirect_to root_path, alert: "You're already part of another wall!"
  end

  def show
    @wall = Wall.find_by_access_code!(params[:id])
    JoinWall.execute(@wall, session)
  rescue JoinWall::GuestAlreadyHasAWall
    redirect_to root_path, alert: "You're already part of another wall!"
  end
end

