class WallsController < ApplicationController
  before_action :autogenerate_guest
  before_action :init_wall, only: %w(show leave)

  def create
    wall = SetupWall.execute(@guest)
    redirect_to wall_path(wall), notice: "Welcome to your wall! Next step: share the link with your friends to let them join the wall!"
  rescue GuestAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  end

  def show
    joined = JoinWall.execute(@guest, @wall)
    if joined
      flash.now[:notice] = "Welcome! You've successfully joined the wall!"
    end
  rescue GuestAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  rescue TooManyUsersOnWallException => e
    redirect_to root_path, alert: "Too late!, this is wall is full... please join another wall, create a new one or just wait for someone else leaving this wall"
  end

  def leave
    LeaveWall.execute(@guest, @wall)
    redirect_to root_path, notice: "You successfully left the wall"
  end

  private

  def init_wall
    @wall = Wall.find_by_access_code!(params[:id])
  end

  def autogenerate_guest
    @guest = SessionManager.new(session).generate_and_sign_in_guest
  end
end

