module Api
  class ImagesController < BaseController
    def upload_request
      apg = AwsPolicyGenerator.execute
      render json: { upload_url: apg.upload_url, url: apg.url }, status: :ok
    end

    def photos
      StorePhoto.execute(params[:s3_url], session)
      render json: nil, status: :ok
    rescue StorePhoto::InvalidInputException
      render json: nil, status: :unprocessable_entity
    end
  end
end

