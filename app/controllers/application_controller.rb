class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def session_manager
    @session_manager ||= SessionManager.new(session)
  end

  delegate :current_user, to: :session_manager
end

