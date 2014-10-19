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
    @account.save

    @account.wall.users << current_user

    respond_with @account
  end

  before_action :requires_user_within_account!, only: :show
  def show
    @wall = current_account.wall
    @user_id = current_user.id
  end

  private

  def permitted_params
    params.require(:account).permit(:name, :slug)
  end

  def current_account
    @account ||= Account.find_by_slug(params[:id])
  end
end

