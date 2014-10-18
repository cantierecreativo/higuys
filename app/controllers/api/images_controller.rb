module Api
  class ImagesController < ApplicationController
    def upload_request
      upload_request = UploadRequest.new

      if upload_request.execute
        render json: { success: true, url: upload_request.url, request_id: upload_request.request_id }, status: :ok
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    end

    def photos
      upload_notifier = UploadNotifier.new

      if upload_notifier.execute
        render json: { success: true },  status: :ok
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    end

  end
end
