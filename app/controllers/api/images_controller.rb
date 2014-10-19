module Api
  class ImagesController < BaseController
    def upload_request
      @wall = Wall.find_by!(access_code: params[:wall_id])
      path = "#{Rails.env}/demo-#{@wall.access_code}/#{SecureRandom.hex}.jpg"
      @apg = AwsPolicyGenerator.execute(path)
      respond_with @apg, status: :ok
    end

    def photos
      @wall = Wall.find_by!(access_code: params[:wall_id])
      StorePhoto.execute(params[:s3_url], session)
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end
  end
end

