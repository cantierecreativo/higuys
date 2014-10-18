module Api
  class ImagesController < BaseController
    def upload_request
      apg = AwsPolicyGenerator.execute
      render json: { upload_url: apg.upload_url, url: apg.url }, status: :ok
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
