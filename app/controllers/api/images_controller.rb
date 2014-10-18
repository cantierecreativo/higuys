module Api
  class ImagesController < BaseController
    def upload_request
      url = AwsPolicyGenerator.execute
      render json: { url: url }, status: :ok
    end

    def photos
      upload_notifier = UploadNotifier.new(params[:s3_url])

      if upload_notifier.execute
        render json: { success: true }, status: :ok
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    end
  end
end

