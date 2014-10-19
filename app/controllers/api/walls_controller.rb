module Api
  class WallsController < BaseController
    before_action :require_user_with_wall!

    def create_upload_policy
      path = "#{Rails.env}/demo-#{wall.access_code}/#{SecureRandom.hex}.jpg"
      @apg = AwsPolicyGenerator.execute(path)
      respond_with @apg, status: :ok
    end

    def create_photo
      StorePhoto.execute(current_user, params[:s3_url])
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end

    def show
      @users = wall.users.active_in_the_last(5.minutes).by_id
      respond_with @users, status: :ok
    end

    def status
      @user = current_user
      @user.update_attributes(status_message: params[:status_message])
      respond_to do |format|
        format.json { render status: :ok }
      end
    end

    private

    def require_user_with_wall!
      valid_api_user = api_user.present? && api_user.wall.present?
      valid_current_user = current_user.present? && current_user.wall.present?

      if !valid_api_user && !valid_current_user
        respond_with_error code: 'INVALID_REQUEST'
      end
    end

    def api_user
      @user ||= if (( header_value = request.headers["HTTP_AUTHORIZATION"] ))
                 User.find_by_secret_token(header_value)
               end
    end

    def wall
      @wall ||= if api_user
                  api_user.wall
                else
                  current_user.wall
                end
    end
  end
end

