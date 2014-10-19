module Api
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    respond_to :json

    private

    def respond_with_error(error)
      respond_to do |format|
        format.json { render json: error, status: :unprocessable_entity }
      end
    end

    def respond_with_success(success)
      respond_to do |format|
        format.json { render json: success, status: :ok }
      end
    end
  end
end

