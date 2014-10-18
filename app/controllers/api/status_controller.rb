class Api::StatusController < Api::BaseController
  respond_to :json

  def index
    @guests = Wall
      .find_by!(access_code: params[:wall_id])
      .guests.by_id

    respond_with @guests, status: :ok
  end
end
