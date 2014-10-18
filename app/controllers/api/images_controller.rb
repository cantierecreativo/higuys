module Api
  class ImagesController < BaseController
    def upload_request
      url = AwsPolicyGenerator.execute
      render json: { url: url }, status: :ok
    end

    def photos
      store_photo = StorePhoto.new(params[:s3_url], session[:guest_id])
      if store_photo.execute
        render json: nil, status: :ok
      else
        render json: nil, status: :unprocessable_entity
      end
    end
  end
end
