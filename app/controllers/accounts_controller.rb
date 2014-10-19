class AccountsController < ApplicationController
  responders :location, :flash
  respond_to :html

  before_action :requires_registered_user!

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(permitted_params)
    @account.build_wall
    if @account.save
      @account.wall.users << current_user
    end

    respond_with @account
  end

  before_action :requires_user_within_account!, only: %i(show leave)
  def show
    @wall = current_account.wall
    @user = current_user
    @pusher_channel = PushEvent.channel_name(@wall)
  end

  def leave
    current_user.update_attributes!(wall: nil)
    PushEvent.execute(current_account.wall, 'leave', user_id: current_user.id)
    redirect_to root_path, notice: "You successfully left the wall"
  end

  private

  def permitted_params
    params.require(:account).permit(:name, :slug)
  end

  def current_account
    @account ||= Account.find_by_slug(params[:id])
  end
end

