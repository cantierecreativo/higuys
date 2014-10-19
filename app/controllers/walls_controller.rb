class WallsController < ApplicationController
  before_action :autogenerate_guest!
  before_action :init_wall, only: %w(show leave)

  def create
    wall = SetupWall.execute(@user)
    redirect_to wall_path(wall), notice: "Welcome to your wall! Next step: share the link with your friends to let them join the wall!"
  rescue UserAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  end

  def show
    joined = JoinWall.execute(@user, @wall)
    @pusher_channel = PushEvent.channel_name(@wall)

    if joined
      flash.now[:notice] = "Welcome! You've successfully joined the wall!"
    end
  rescue UserAlreadyHasAWallException => e
    redirect_to wall_path(e.wall), alert: "Ouch, You're already part of another wall... please leave this wall before creating a new one!"
  rescue TooManyUsersOnWallException => e
    LeaveWall.execute(@user, @wall)
    redirect_to root_path, alert: "Too many people! This is wall is full... please create a new one!"
  end

  def leave
    LeaveWall.execute(@user, @wall)
    redirect_to root_path, notice: "You successfully left the wall"
  end

  private

  def init_wall
    @wall = Wall.find_by_access_code!(params[:id])
  end

  def autogenerate_guest!
    @user ||= session_manager.generate_and_sign_in_guest
  end
end

