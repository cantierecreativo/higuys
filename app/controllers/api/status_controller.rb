class Api::StatusController < Api::BaseController
  def index
    @guests = Wall
      .find_by!(access_code: params[:wall_id])
      .guests.active.by_id

    respond_with @guests, status: :ok
  end
end

