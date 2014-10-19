module Api
  class WallsController < BaseController
    before_action :require_guest_with_wall!

    def create_upload_policy
      path = "#{Rails.env}/demo-#{@guest.wall.access_code}/#{SecureRandom.hex}.jpg"
      @apg = AwsPolicyGenerator.execute(path)
      respond_with @apg, status: :ok
    end

    def create_photo
      StorePhoto.execute(@guest, params[:s3_url])
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end

    def show
      @guests = @guest.wall.guests.active_in_the_last(5.minutes).by_id
      respond_with @guests, status: :ok
    end

    private

    def require_guest_with_wall!
      @guest = SessionManager.new(session).current_guest
      if @guest.nil? || @guest.wall.nil?
        respond_with_error code: 'INVALID_REQUEST'
      end
    end
  end
end

