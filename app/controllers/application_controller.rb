class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def session_manager
    @session_manager ||= SessionManager.new(session)
  end

  delegate :current_user, to: :session_manager
  helper_method :current_user

  def requires_registered_user!
    unless current_user.is_a? RegisteredUser
      session[:redirect_after_auth] = request.fullpath
      redirect_to sign_in_path, alert: 'To access the page you first have to sign in!'
    end
  end

  def requires_user_within_account!
    requires_account!

    if !current_user.wall || current_user.wall.account != @account
      redirect_to root_path, alert: 'You tried!'
    end
  end

  def requires_account!
    current_account or raise ActiveRecord::RecordNotFound
  end

  def current_account
    @account ||= Account.find_by_slug(params[:account_id])
  end
  helper_method :current_account
end
