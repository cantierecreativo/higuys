class InvitationsController < ApplicationController
  before_action :requires_user_within_account!
  responders :location, :flash

  def index
    @invitations = current_account.invitations
  end

  def create
    InviteFriend.execute(current_account, permitted_params)
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    respond_with @invitation
  end
end

