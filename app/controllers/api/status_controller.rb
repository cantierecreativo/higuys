class Api::StatusController < Api::BaseController
  def index
    guests = Wall.find_by!(access_code: params[:wall_id])
      .guests.by_id
      .map(&:to_json)

    render json: guests, status: :ok
  end
end
