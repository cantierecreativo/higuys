class WallsController < ApplicationController
  def create
    wall = SetupWall.execute(session)
    redirect_to wall_path(wall)
  end

  def show
  end
end

