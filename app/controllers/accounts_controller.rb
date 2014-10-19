class AccountsController < ApplicationController
  responders :location, :flash
  respond_to :html

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(permitted_params)
    @account.build_wall
    @account.save

    respond_with @account
  end

  def show
    @account = Account.find_by_slug(params[:id])
    @wall = @account.wall
    @guest_id = 1
  end

  private

  def permitted_params
    params.require(:account).permit(:name, :slug)
  end
end

