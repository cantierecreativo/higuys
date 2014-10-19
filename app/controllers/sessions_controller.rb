class SessionsController < ApplicationController
  def prepare
  end

  def create
    session_manager.generate_and_sign_in_registered_user(auth_hash.uid, auth_hash.info.email)
    redirect_path = session.delete(:redirect_after_auth) || root_path
    redirect_to redirect_path, notice: 'Signed in successfully!'
  end

  def force_signin_in_test
    user = RegisteredUser.find(params[:user_id])
    session_manager.sign_in(user)
    redirect_to session.fetch(:redirect_after_auth, root_path)
  end

  def oauth_failure
    redirect_to root_path, alert: 'Sorry, some errors occurred during the authentication with Github!'
  end

  def destroy
    session_manager.sign_out
    redirect_to root_path, notice: "You've successfully signed out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end

