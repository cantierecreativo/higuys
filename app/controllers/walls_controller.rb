class WallsController < ApplicationController
  def create
    wall = SetupWall.execute(session)
    redirect_to wall_path(wall), notice: "Welcome to your wall! Next step: share the link with your friends to let them join the wall!"
  rescue GuestAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  end

  def show
    @wall = Wall.find_by_access_code!(params[:id])
    joined = JoinWall.execute(@wall, session)
    if joined
      flash.now[:notice] = "Welcome! You've successfully joined the wall!"
    end
  rescue GuestAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  end

  def leave
    @wall = Wall.find_by_access_code!(params[:id])
    LeaveWall.execute(@wall, session)
    redirect_to root_path, notice: "You successfully left the wall"
  end
end

