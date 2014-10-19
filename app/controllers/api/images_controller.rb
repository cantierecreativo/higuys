module Api
  class ImagesController < BaseController
    def upload_request
      @apg = AwsPolicyGenerator.execute
      respond_with @apg, status: :ok
    end

    def photos
      StorePhoto.execute(params[:s3_url], session)
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end
  end
end
