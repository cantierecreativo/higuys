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
      redirect_to prepare_auth_path, alert: 'To access the page you first have to sign in!'
    end
  end
end

