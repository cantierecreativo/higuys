module Api
  class WallsController < BaseController
    before_action :require_user_with_wall!
    before_action :require_permissions_if_account!

    def create_upload_policy
      path = "#{Rails.env}/demo-#{current_user.wall.access_code}/#{SecureRandom.hex}.jpg"
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
      @users = current_user.wall.users.active_in_the_last(5.minutes).by_id
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
      if current_user.nil? || current_user.wall.nil?
        respond_with_error code: 'INVALID_REQUEST'
      end
    end

    def require_permissions_if_account
      if current_user.wall.account
      end
    end
  end
end

