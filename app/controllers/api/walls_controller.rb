module Api
  class WallsController < BaseController
    before_action :require_user_with_wall!

    def create_upload_policy
      path = "#{Rails.env}/demo-#{@user.wall.access_code}/#{SecureRandom.hex}.jpg"
      @apg = AwsPolicyGenerator.execute(path)
      respond_with @apg, status: :ok
    end

    def create_photo
      StorePhoto.execute(@user, params[:s3_url])
      respond_with_success code: 'OK'
    rescue StorePhoto::InvalidInputException
      respond_with_error code: 'INVALID_REQUEST'
    end

    def show
      @users = @user.wall.users.active_in_the_last(5.minutes).by_id
      respond_with @users, status: :ok
    end

    private

    def require_user_with_wall!
      @user = SessionManager.new(session).current_user
      if @user.nil? || @user.wall.nil?
        respond_with_error code: 'INVALID_REQUEST'
      end
    end
  end
end

