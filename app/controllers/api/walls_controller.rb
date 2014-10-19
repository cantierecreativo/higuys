module Api
  class WallsController < BaseController
    before_action :require_user_with_wall!

    def create_upload_policy
      path = "#{Rails.env}/demo-#{wall.access_code}/#{SecureRandom.hex}.jpg"
      @apg = AwsPolicyGenerator.execute(path)
      respond_with @apg, status: :ok
    end

    def create_photo
      StorePhoto.execute(valid_user, params[:s3_url])
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end

    def show
      @users = wall.users.active_in_the_last(5.minutes).by_id
      respond_with @users, status: :ok
    end

    def status
      @user = valid_user
      @user.update_attributes(status_message: params[:status_message])
      respond_to do |format|
        format.json { render status: :ok }
      end
    end

    private

    def require_user_with_wall!
      if !valid_user.present? || !valid_user.wall.present?
        respond_with_error code: 'INVALID_REQUEST'
      end
    end

    def valid_user
      api_user || current_user
    end

    def api_user
      @user ||= if (( header_value = request.headers["HTTP_AUTHORIZATION"] ))
                  User.find_by_secret_token(header_value)
                end
    end

    def wall
      @wall ||= valid_user.wall
    end
  end
end
