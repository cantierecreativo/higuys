class InvitationsController < ApplicationController
  before_action :requires_user_within_account!
  responders :location, :flash
  respond_to :html

  def index
    @invitations = current_account.invitations
  end

  def create
    @invitation = InviteFriend.execute(current_account, permitted_params)
    respond_with @invitation, location: account_invitations_path(current_account)
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    respond_with @invitation
  end

  private

  def permitted_params
    params.require(:invitation).permit(:email)
  end
end

