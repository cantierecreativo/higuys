class SessionsController < ApplicationController
  def prepare
  end

  def create
    session_manager.generate_and_sign_in_registered_user(auth_hash.uid)
    redirect_to session.fetch(:redirect_after_auth, root_path), notice: 'Registration completed successfully!'
  end

  def force_signin_in_test
    user = RegisteredUser.find(params[:user_id])
    session_manager.sign_in(user)
    redirect_to session.fetch(:redirect_after_auth, root_path)
  end

  def oauth_failure
    redirect_to root_path, alert: 'Sorry, some errors occurred during the authentication with Github!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end

